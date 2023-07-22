(*
  Run with:

    PGHOST=localhost PGDATABASE=caqti_study PGPORT=5433 dune exec ./bin/cli_app.exe
*)

open Printf
module Init = Repo.Init
module Author = Repo.Author

let help =
  {|
  This REPL accepts commands of the following form:

  - { ACTION }
  - { RESOURCE } { ACTION }

  Examples:

    - help
    - quit
    - author ls
    - author find 1
    - author insert

  NOTE:

    Once you enter a "resource" command (e.g. `author ls`), your REPL state changes, like this:

      author> CURSOR_HERE

    In this mode the "resource" prefix is already set. So you just enter "ls", "find 1", etc.

    Type "main" (or Ctrl+D) to drop back to the main REPL.

  |}

let get_line () = In_channel.input_line In_channel.stdin

let print_header str =
  print_string str;
  print_string "> ";
  flush Out_channel.stdout

let get_args () =
  print_header "author";
  match get_line () with None -> [] | Some str -> String.split_on_char ' ' str

(** It is assumed these command won't fail at runtime, given the fact they've been tested.
    Regardless, we probably don't want to print a specific error message in this context *)
let run promise f =
  match Lwt_main.run promise with
  | Error _ -> print_endline "Sorry, something went wrong!"
  | Ok x -> f x

let print_author (id, first_name) = printf "%d) %s\n%!" id first_name

let print_author_opt = function
  | None -> print_endline "Author not found!"
  | Some x -> print_author x

let rec author_repl conn args =
  let again = author_repl conn in
  match args with
  | [] | "main" :: [] ->
      (* Ctrl+D or typed "main" *)
      print_newline ()
  | "ls" :: [] ->
      run (Author.ls' conn) @@ List.iter print_author;
      again (get_args ())
  | "insert" :: [] ->
      print_endline "will start author insert mode";
      again (get_args ())
  | [ "find"; id ] ->
      run (Author.find_by_id conn id) print_author_opt;
      again (get_args ())
  | _ ->
      print_endline "Unknown author command or sub-command!";
      again (get_args ())

let rec main_repl conn =
  print_header "main";
  match get_line () with
  | Some line -> (
      match line |> String.split_on_char ' ' with
      | "quit" :: [] -> print_endline "Bye bye!"
      | "help" :: [] ->
          print_endline help;
          main_repl conn
      | "author" :: args ->
          author_repl conn args;
          main_repl conn
      | _ ->
          print_endline "Unknown command!";
          main_repl conn)
  | None ->
      (* Ctrl+D *)
      print_newline ();
      print_endline "See you next time!";
      ()

let () =
  match Lwt_main.run (Init.connect ()) with
  | Error err ->
      print_endline "Can't start the app! I could not connect to the database!!";
      prerr_endline (Caqti_error.show err)
  | Ok conn ->
      print_endline {|Welcome to our CLI app! (type "help" to learn more)|};
      main_repl conn
