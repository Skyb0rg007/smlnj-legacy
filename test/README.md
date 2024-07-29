
# SML/NJ Testing Infrastructure

This directory includes a simple library for unit testing,
property-based testing, and benchmarking.
The hope is to cover the behavior of the SML basis and SML/NJ libraries,
to allow for better specification of the behavior of the system.

# Running Tests

TODO

# Writing Tests

The testing library is designed to be lightweight and specialized for the
compiler's use cases.
As a result, this library is not intended to be a public-facing part of the
SML/NJ system.
However, this may change at some point in the future.

## Unit tests

The primary interface is based on [Characterization tests][1], also known as
Golden Master Tests.
To write unit tests for a given library, one creates a directory to store
the input/output pairs for different program behaviors.
Then the author creates a testing SML file that hooks up the library to
string inputs and string outputs.
Next, the author writes example inputs for each of these functions.
After the first run of the testing program, there should be an output file
that contains the output of running the program with the given input.
In subsequent executions, the generated output will instead be compared
against the input, and a failure will be issued if there is a mismatch.

The design allows for a simple decoupling of the testing infrastructure from
the test cases themselves.
Once a library is integrated into the testing infrastructure,
writing additional tests is as simple as writing an input file,
automatically generating an output file,
then committing them to the repo.
This also documents API changes, since a change could intentionally change
program output.
In that case, there is a git-based documentation on when that change occurred.

### Advantages

1. Complex testing inputs are easy to write
   - Generating a large JSON file is easier and simpler than writing a large
     `JSON.value` in code.
   - Some inputs may depend on binary or Unicode data that is easier
     to handle in separate files.
   - Comparing outputs can be done in specialized programs such as `vimdiff`,
     and don't require SML code to render.
2. Testing outputs can be auto-generated
   - SML/NJ is a large piece of software.
     Cutting down on half of the code is a huge help.
   - Adding additional tests can be done without touching any code.
3. Behavior changes are documented in Git
   - When something changes, the testing library will yell at you
     (Eventually this will be integrated into a GitHub workflow).
     This way it's simpler to find out where something "broke".
   - While the SML testing file may change as new functions are added or removed,
     the input/output files will rarely change.
     This makes a change easy to categorize as breaking or not.

### Disadvantages

1. Does not actually guarentee correctness
   - Output is auto-generated, so may be encoding incorrect behavior as a test.

## Property Tests

[Property testing][2] is a testing technique that generates random inputs
and asserts their correctness.
This form of test requires much more effort on the part of the test-writer,
but has a much better capability of detecting faulty behavior.

# The interface

The testing interface consists of the `SMLNJTest` structure which
has the following signature.

```sml
structure SMLNJTest : sig

  (* Hook a function up to the characterization testing infrastructure
   * [unitTest {parseInput, renderOutput} (name, function)]
   *
   * parseInput: Convert a file's content to a valid input to the function
   * renderOutput: Convert the output to a total string representation
   * name: A short description of the function this is testing
   *       This string is used to create the filenames and must be unique
   * function: The function to test
   *
   * This function is intended to be partially applied and re-used.
   *)
  val unitTest : {parseInput: string -> 'a, renderOutput : 'b -> string}
              -> string * ('a -> 'b) -> unit

  (* Hook up a function for rendering a exceptions for the library
   * Certain exceptions contain payloads that should be tested, but there
   * is no generic lossless mechanism for converting them into strings.
   * The registered function will be called on those exceptions,
   * with a `SOME` response indicating a handled exception.
   *)
  val renderException : (exn -> string option) -> unit

  (* Call this once you're done calling tests.
   * This will print the number of tests run and exit with a status code. *)
  val finish : unit -> 'a
end
```

[1]: https://en.wikipedia.org/wiki/Characterization_test "Characterization test"
[2]: https://en.wikipedia.org/wiki/Software_testing#Property_testing "Property testing"
