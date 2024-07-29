
structure SMLNJTest : SMLNJ_TEST =
struct

  (* Testing State *)
  val SUCCESSES = ref 0
  val FAILURES = ref 0
  val DATA_DIR = ref ""
  val RENDER_EXN = ref (fn e => (raise e) : string)

  (* Helpers *)

  exception WrappedExn of exn

  fun exnToString e = !RENDER_EXN e ^ "\n"

  val defaultRenderException =
    fn Bind => SOME "uncaught exception Bind"
     | Match => SOME "uncaught exception Match"
     | Subscript => SOME "uncaught exception Subscript"
     | Size => SOME "uncaught exception Size"
     | Overflow => SOME "uncaught exception Overflow"
     | Chr => SOME "uncaught exception Chr"
     | Div => SOME "uncaught exception Div"
     | Domain => SOME "uncaught exception Domain"
     | Span => SOME "uncaught exception Span"
     | Fail msg => SOME (concat ["uncaught exception (Fail \"", String.toString msg, "\")"])
     | Date.Date => SOME "uncaught exception Date.Date"
     | List.Empty => SOME "uncaught exception List.Empty"
     | ListPair.UnequalLengths => SOME "uncaught exception ListPair.UnequalLengths"
     | Option.Option => SOME "uncaught exception Option.Option"
     | Time.Time => SOME "uncaught exception Time.Time"
     | OS.IO.Poll => SOME "uncaught exception OS.IO.Poll"
     | OS.Path.Path => SOME "uncaught exception OS.Path.Path"
     | OS.SysErr (desc, optCond) => let
         val condStr =
           case optCond
             of NONE => "NONE"
              | SOME cond => "SOME " ^ OS.errorMsg cond
         in
           SOME (concat ["uncaught exception (OS.SysErr (\"",
                         String.toString desc, "\", ", condStr, "))"])
         end
     | IO.Io {cause, function, name} => let
         val causeStr = !RENDER_EXN cause
         in
           SOME (concat ["uncaught exception (IO.Io {cause=",
                         causeStr,
                         ", function=\"", String.toString function,
                         "\", name=\"", String.toString name, "\"})"])
         end
     | _ => NONE

  val stringToFilename = String.map
    (fn #" " => #"-"
      | c =>
          if Char.isAlphaNum c orelse c = #"_"
            then c
            else raise Fail "SMLNJTest: descriptions must only contain [a-zA-Z0-9_]")

  fun fileContent filename = let
        val file = BinIO.openIn filename
        val content = BinIO.inputAll file
        in
          BinIO.closeIn file;
          Byte.bytesToString content
        end
        handle e => raise e

  fun fileContent' filename =
        SOME (fileContent filename)
        handle IO.Io {function="openIn", ...} => NONE

  fun writeContent (filename, content) = let
        val file = BinIO.openOut filename
        in
          BinIO.output (file, Byte.stringToBytes content);
          BinIO.closeOut file
        end

  fun removeFile filename =
        OS.FileSys.remove filename
        handle OS.SysErr _ => ()

  fun setDataDir dir = DATA_DIR := dir

  fun dataDir base =
        if !DATA_DIR = ""
          then raise Fail "SMLTest: data dir unset"
          else OS.Path.concat (!DATA_DIR, base)

  val pr = TextIO.print
  fun nl () = TextIO.output1 (TextIO.stdOut, #"\n")

  fun note str = (pr "# "; pr str; nl ())

  fun ok label = (
        SUCCESSES := !SUCCESSES + 1;
        pr "ok ";
        pr (Int.toString (!FAILURES + !SUCCESSES));
        pr " - ";
        pr label;
        nl ())

  fun notOk label = (
        FAILURES := !FAILURES + 1;
        pr "not ok ";
        pr (Int.toString (!FAILURES + !SUCCESSES));
        pr " - ";
        pr label;
        nl ())

  (* Interface *)

  fun renderException f = let
        val old = !RENDER_EXN
        fun new e =
              case f e
                of NONE => old e
                 | SOME str => str
        in
          RENDER_EXN := new
        end

  val () = renderException defaultRenderException

  fun finish () = (
        pr "1.."; pr (Int.toString (!FAILURES + !SUCCESSES)); nl ();
        if !FAILURES > 0
          then OS.Process.exit OS.Process.failure
          else OS.Process.exit OS.Process.success)

  fun goldenTests (base, name, k) = let
        val outDir = OS.FileSys.openDir (dataDir base)
        handle OS.SysErr _ => (OS.FileSys.mkDir (dataDir base); OS.FileSys.openDir (dataDir base))

        fun runTestFirst (label, infile, outfile) = let
              val () = k {infile=infile, outfile=outfile}
              in
                note "Running test for the first time";
                note ("output = \"" ^ fileContent outfile ^ "\"");
                ignore (fileContent outfile);
                ok label
              end

        fun runTest (label, infile, actfile, expected) = let
              val () = k {infile=infile, outfile=actfile}
              val actual = fileContent actfile
              in
                if expected = actual
                  then ok label
                  else (notOk label;
                        note ("expected = \"" ^ expected ^ "\"");
                        note ("actual = \"" ^ actual ^ "\""))
              end

        fun visitInput (infile, base, file) = let
              val infile = OS.Path.joinBaseExt {base=base, ext=SOME "input"}
              val outfile = OS.Path.joinBaseExt {base=base, ext=SOME "output"}
              val actfile = OS.Path.joinBaseExt {base=base, ext=SOME "output.actual"}
              val expected = fileContent' outfile
              val label = concat [name, ": ", file]
              in
                removeFile actfile;
                case expected
                  of SOME data => runTest (label, infile, actfile, data)
                   | NONE => runTestFirst (label, infile, outfile)
              end

        fun visit () =
          case OS.FileSys.readDir outDir
            of NONE => ()
             | SOME filename => let
                 val {base=fileBase, ext} = OS.Path.splitBaseExt filename
                 handle e => raise e
                 in
                   if ext = SOME "input"
                     then let
                       in
                         visitInput (filename, OS.Path.concat (dataDir base, fileBase), fileBase)
                       end
                     else ();
                   visit ()
                 end
        in
          visit ()
        end

  fun unitTest {parseInput, renderOutput} (name, function) = let
        (* Need to use WrappedExn to ensure we don't catch exceptions
         * raised from `parseInput` and `parseOutput` *)
        fun run strInput = let
              val input = parseInput strInput
              val output = function input handle e => raise WrappedExn e
              in
                renderOutput output
              end
              handle WrappedExn e => exnToString e
        fun f {infile, outfile} = let
              val input = fileContent infile
              val actual = run input
              in
                writeContent (outfile, actual)
              end
        in
          goldenTests (stringToFilename name, name, f)
        end

  fun unitTestFile (name, function) = let
        (* Need to use WrappedExn to ensure we don't catch exceptions
         * raised from `parseInput` and `parseOutput` *)
        fun f {infile, outfile} =
              function {infile=infile, outfile=outfile}
              handle e => (removeFile outfile; writeContent (outfile, exnToString e))
        in
          goldenTests (stringToFilename name, name, f)
        end

end
