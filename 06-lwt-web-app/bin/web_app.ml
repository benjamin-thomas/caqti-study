(*
   Start the API server with:
   make -C .. db-reset && PGHOST=localhost PGDATABASE=caqti_study PGPORT=5433 dune exec ./bin/web_app.exe

   Start the frontend server with:
   - cd ./lib/web/front
   - foreman start -f Procfile.dev
*)

let () =
  let init =
    let open Lwt_result.Syntax in
    let* pool = Repo.Init.make_pool () in
    let* () = Caqti_lwt.Pool.use Repo.Init.create_tables pool in
    let* () = Caqti_lwt.Pool.use Repo.Init.seed pool in
    Lwt.return_ok pool
  in
  match Lwt_main.run init with
  | Error err ->
    print_endline "Can't start the app! I could not connect to the database!!";
    prerr_endline (Caqti_error.show err)
  | Ok pool -> Web_server.Init.go pool
;;
