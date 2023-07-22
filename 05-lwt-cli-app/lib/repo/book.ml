module Q = struct
  open Caqti_request.Infix

  (*
    Caqti infix operators

    ->! decodes a single row
    ->? decodes zero or one row
    ->* decodes many rows
    ->. expects no row
  *)

  let count = Caqti_type.(unit ->! int) {|
    SELECT COUNT(*) FROM book
    |}

  let insert =
    Caqti_type.(string ->. unit)
      {|
       INSERT INTO book (title) VALUES (?)
      |}

  let insert' =
    Caqti_type.(string ->! int)
      {|
       INSERT INTO book (title) VALUES (?) RETURNING id
      |}
end

type book = { title : string }

let count (module Conn : Caqti_lwt.CONNECTION) = Conn.find Q.count ()

let insert (module Conn : Caqti_lwt.CONNECTION) (b : book) =
  Conn.exec Q.insert b.title

let insert' (module Conn : Caqti_lwt.CONNECTION) (b : book) =
  Conn.find Q.insert' b.title
