val with_conn :
  (Caqti_eio.connection ->
  ('a, ([> Caqti_error.load_or_connect ] as 'b)) result) ->
  ('a, 'b) result
(** [with_conn f] applies [f] with a new [Caqti_eio.connection].

    Example:
    {[
      with_conn (fun conn -> ask_db conn "123")
    ]}

*)
