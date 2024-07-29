
signature SMLNJ_TEST = sig

  val unitTest : {parseInput : string -> 'a, renderOutput : 'b -> string}
              -> string * ('a -> 'b)
              -> unit

  val unitTestFile :
              string * ({infile: string, outfile: string} -> unit)
              -> unit

  val renderException : (exn -> string option) -> unit
  val setDataDir : string -> unit

  val finish : unit -> 'a

end
