(*
   Run with:
   PGHOST=localhost PGDATABASE=caqti_study PGPORT=5433 dune exec ./bin/web_app.exe

   NOTE:
   Run the "simple" app first to seed the database
*)
(*
   open Printf

   (** It is assumed these command won't fail at runtime, given the fact they've been tested.
   Regardless, we probably don't want to print a specific error message in this context *)
   let run_promise p f =
   match Lwt_main.run p with
   | Error _ -> print_endline "Sorry, something went wrong!"
   | Ok x -> f x
   ;;

   module Validate = struct
   let len_gte n input =
   if String.length input >= n then
   Ok input
   else
   Error "Length must be greater than or equal to 3"
   [@@ocamlformat "disable"]
   end *)

let () = Web_server.Init.go ()
