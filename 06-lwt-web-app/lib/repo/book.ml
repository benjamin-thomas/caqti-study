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

  let ls = Caqti_type.(unit ->* tup2 int string) {|SELECT id, title FROM book|}

  let find_by_id =
    Caqti_type.(string ->? tup2 int string) {|SELECT id, title FROM book WHERE id = ?|}
  ;;

  let insert =
    Caqti_type.(string ->. unit) {|
       INSERT INTO book (title) VALUES (?)
      |}
  ;;

  let insert' =
    Caqti_type.(string ->! int)
      {|
       INSERT INTO book (title) VALUES (?) RETURNING id
      |}
  ;;
end

type book = { title : string }

let count (module Conn : Caqti_lwt.CONNECTION) = Conn.find Q.count ()
let ls (module Conn : Caqti_lwt.CONNECTION) = Conn.collect_list Q.ls ()

(* (module DB) -> (int * string) list Lwt.t *)
(* let list (module Db : DB) =
   let%lwt comments_or_error = Db.collect_list ls () in
   Caqti_lwt.or_fail comments_or_error
   ;; *)

let find_by_id (module Conn : Caqti_lwt.CONNECTION) id = Conn.find_opt Q.find_by_id id
let insert (module Conn : Caqti_lwt.CONNECTION) (b : book) = Conn.exec Q.insert b.title
let insert' (module Conn : Caqti_lwt.CONNECTION) (b : book) = Conn.find Q.insert' b.title
