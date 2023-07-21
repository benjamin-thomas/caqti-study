(*
  Run with one of:

    - PGHOST=localhost PGDATABASE=caqti_study PGPORT=5433 dune runtest --watch
    - PGHOST=localhost PGDATABASE=caqti_study PGPORT=5433 dune build @all @runtest --watch
 *)

(* let%test_unit "PostgreSQL: add (asynchronously)" =
     let ( => ) = [%test_eq: (Base.int, Base.string) Base.Result.t] in
     let will_add a b =
       let ( let* ) = Lwt_result.bind in
       let* conn = fresh_db () |> str_error in
       Repo.Exec.add conn a b |> str_error
     in
     Lwt_main.run (will_add 1 2) => Ok 3;
     Lwt_main.run (will_add 2 3) => Ok 5

   let fail e = failwith @@ "test setup failed: " ^ Caqti_error.show e *)
