# Hello, caqti-eio!

Let's look at [eio](https://github.com/ocaml-multicore/eio)!

Instead of promises, we will instead use a "direct style" concurrency model.

> NOTE: OCaml v5 or greater is required.

As always let's run our tests:

```
cd ./hello-caqti-eio
PGHOST=localhost PGDATABASE=caqti_study PGPORT=5433 dune exec ./bin/main.exe
PGHOST=localhost PGDATABASE=caqti_study PGPORT=5433 dune runtest --watch
```

## Test via the REPL

```
$ PGHOST=localhost PGDATABASE=caqti_study PGPORT=5433 dune utop
```

Firstly, let's bring the `Init` and `Exec` modules into scope:
```ocaml
# open Repo
```

Also, we will create this helper function, for demonstration purposes.

```ocaml
# let with_conn f = Result.get_ok @@ Eio_main.run @@ Init.with_conn @@ f;;
val with_conn :
  (Caqti_eio.connection -> ('a, [> Caqti_error.load_or_connect ]) result) ->
  'a = <fun>
```

Now we can query the database!

```ocaml
# with_conn @@ Exec.add 1 2;;
- : int = 3
```

Note that the functions are rather terse, thanks to currying.

Here's the fully expanded version:

```ocaml
# Result.get_ok @@ Eio_main.run @@ fun env -> Repo.Init.with_conn (fun conn -> Repo.Exec.add 1 2 conn) env
- : int = 3
```
