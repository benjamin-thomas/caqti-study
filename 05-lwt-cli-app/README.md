# Lwt CLI app

Now, that we have acquired enough knowledge, we will build the app mentioned in the main `README`. The user will generate `CRUD` queries via a CLI.


Let's insist once more about the fact that `map` = `bind` + `return`.

Here's an example of five equivalent functions to illustrate and also show possible syntax variations:

```ocaml
module Init = Repo.Init
module Author = Repo.Author

open Lwt_result.Syntax

let will_get_author_v1 () : ('author, 'error) result Lwt.t =
  let* conn = Init.connect () in
  let* author = Author.find_by_id conn 1 in
  Lwt.return (Ok author)

let will_get_author_v2 () : ('author, 'error) result Lwt.t =
  let* conn = Init.connect () in
  let* author = Author.find_by_id conn 1 in
  Lwt.return_ok author

let will_get_author_v3 () : ('author, 'error) result Lwt.t =
  let* conn = Init.connect () in
  Lwt.map (fun author -> author) (Author.find_by_id conn 1)

let will_get_author_v4 () : ('author, 'error) result Lwt.t =
  let* conn = Init.connect () in
  let+ author = Author.find_by_id conn 1 in
  author

let will_get_author_v5 () : ('author, 'error) result Lwt.t =
  let* conn = Init.connect () in
  Author.find_by_id conn 1
```

```
cd ./05-lwt-cli-app
PGHOST=localhost PGDATABASE=caqti_study PGPORT=5433 dune exec ./bin/main.exe
PGHOST=localhost PGDATABASE=caqti_study PGPORT=5433 dune dune runtest --watch
```

```
$ cd ./05-lwt-cli-app
$ make -C .. db-reset
$ PGHOST=localhost PGDATABASE=caqti_study PGPORT=5433 dune utop
utop # open Repo;;
utop # let conn = Init.connect_exn ();;
utop # Init.create_tables conn;;
```