(*
  If we can get access to some env vars, we construct a special URI to use our local DB.
  Otherwise, we return a default URI. We would then use our system DB.
*)
let get_uri () =
  let env_vars =
    let ( let* ) = Option.bind in
    let* pg_host = Sys.getenv_opt "PGHOST" in
    let* pg_port = Sys.getenv_opt "PGPORT" in
    let* pg_database = Sys.getenv_opt "PGDATABASE" in
    Some (pg_host, pg_port, pg_database)
  in
  match env_vars with
  | Some (pg_host, pg_port, pg_database) ->
      Printf.sprintf "postgresql://%s:%s/%s" pg_host pg_port pg_database
  | None -> "postgresql://"

(*
  NOTE: We use the [:>] operator to force a type coersion between the more
  general [Eio_unix.Stdenv.base] type, to the more specific (but still
  compatible) [Caqti_eio.stdenv] type.
*)
let with_conn f (env : Eio_unix.Stdenv.base) =
  let uri = Uri.of_string @@ get_uri () in
  Caqti_eio_unix.with_connection uri ~stdenv:(env :> Caqti_eio.stdenv) f
