
structure JSONTest =
struct
  structure T = SMLNJTest

  val () = T.setDataDir "json-lib/data"


  (* JSON structure *)
  fun renderJSON JSON.NULL = "NULL"
    | renderJSON (JSON.BOOL b) = "BOOL " ^ Bool.toString b
    | renderJSON (JSON.INT i) = "INT " ^ IntInf.toString i
    | renderJSON (JSON.FLOAT r) = "FLOAT " ^ Real.toString r
    | renderJSON (JSON.STRING s) = "STRING \"" ^ String.toString s ^ "\""
    | renderJSON (JSON.OBJECT kvs) = let
        fun kv (k, v) = concat ["(\"", String.toString k, "\",", renderJSON v, ")"]
        in "OBJECT [" ^ String.concatWithMap "," kv kvs ^ "]" end
    | renderJSON (JSON.ARRAY vs) =
        "ARRAY [" ^ String.concatWithMap "," renderJSON vs ^ "]"

  val renderJSON = fn json => renderJSON json ^ "\n"

  fun id x = x

  (* JSONParser structure *)
  fun parseJSON str = let
        val source = JSONParser.openString str
        val json = JSONParser.parse source
        in JSONParser.close source; json end
  val () = T.unitTest {parseInput=id, renderOutput=renderJSON}
    ("JSONParser parse string", parseJSON)
  val () = T.unitTestFile
    ("JSONParser parse file", fn {infile, outfile} => let
       val source = JSONParser.openFile infile
       val json = JSONParser.parse source
       val out = TextIO.openOut outfile
       in TextIO.output (out, renderJSON json);
          JSONParser.close source;
          TextIO.closeOut out
       end)

  (* JSONPrinter structure *)
  val () = T.unitTestFile ("JSONPrinter print", fn {infile, outfile} => let
        val json = JSONParser.parseFile infile
        val out = TextIO.openOut outfile
        in JSONPrinter.print (out, json);
           TextIO.closeOut out
        end)

  val () = T.finish ()
end
