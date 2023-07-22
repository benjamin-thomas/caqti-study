open Printf

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

let rec author_repl args =
  match args with
  | [] | "main" :: [] ->
      (* Ctrl+D or typed "main" *)
      ()
  | "ls" :: [] ->
      print_endline "will list authors";
      author_repl (get_args ())
  | "insert" :: [] ->
      print_endline "will start author insert mode";
      author_repl (get_args ())
  | [ "find"; id ] ->
      printf "will search author: %s\n%!" id;
      author_repl (get_args ())
  | _ ->
      print_endline "Unknown author command or sub-command!";
      author_repl (get_args ())

let rec main_repl () =
  print_header "main";
  match get_line () with
  | Some line -> (
      match line |> String.split_on_char ' ' with
      | "quit" :: [] -> print_endline "Bye bye!"
      | "help" :: [] ->
          print_endline help;
          main_repl ()
      | "author" :: args ->
          author_repl args;
          main_repl ()
      | _ ->
          print_endline "Unknown command!";
          main_repl ())
  | None ->
      (* Ctrl+D *)
      print_newline ();
      print_endline "See you next time!";
      ()

let () =
  print_endline {|Welcome to our CLI app! (type "help" to learn more)|};
  main_repl ()
