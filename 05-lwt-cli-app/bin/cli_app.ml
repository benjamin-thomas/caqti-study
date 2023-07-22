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

let print_authors conn =
  let print_author (id, last_name) = printf "%d) %s\n%!" id last_name in
  match Lwt_main.run (Author.ls' conn) with
  | Error _ -> print_endline "Sorry, something went wrong!"
  | Ok authors -> List.iter print_author authors

let rec author_repl conn args =
  let repl_me = author_repl conn in
  match args with
  | [] | "main" :: [] ->
      (* Ctrl+D or typed "main" *)
      print_newline ()
  | "ls" :: [] ->
      print_authors conn;
      repl_me (get_args ())
  | "insert" :: [] ->
      print_endline "will start author insert mode";
      repl_me (get_args ())
  | [ "find"; id ] ->
      printf "will search author: %s\n%!" id;
      repl_me (get_args ())
  | _ ->
      print_endline "Unknown author command or sub-command!";
      repl_me (get_args ())

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
  | Error x ->
      print_endline "Can't start the app! I could not connect to the database!!";
      prerr_endline (Caqti_error.show x)
  | Ok conn ->
      print_endline {|Welcome to our CLI app! (type "help" to learn more)|};
      main_repl conn
