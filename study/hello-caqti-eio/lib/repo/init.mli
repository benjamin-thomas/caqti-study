val with_conn :
  (Caqti_eio.connection ->
  ('a, ([> Caqti_error.load_or_connect ] as 'e)) result) ->
  Eio_unix.Stdenv.base ->
  ('a, 'e) result
(** [with_conn f env] runs [f] with the given eio environment.

    Example:
    {[
      with_conn (fun conn -> Repo.Exec.add 1 2 conn) env
    ]}

*)
