module Handler = struct
  let root _ = Dream.html "Hello, world!"
  let echo word = Dream.html (Printf.sprintf "echo is -> %s" word)

  (** Conforms to Dream's expectations *)
  let or_fail f conn =
    let%lwt result = f conn in
    Caqti_lwt.or_fail result
  ;;

  module Book = struct
    open Ppx_yojson_conv_lib.Yojson_conv.Primitives

    (* type book =
      { id : int
      ; name : string
      }
    [@@deriving yojson] *)

    (* type book = Shared.Entity.book *)

    let get_all req =
      let%lwt books = Dream.sql req (or_fail Repo.Book.ls) in
      let to_book (id, name) =
        (* let open Shared.Entity in *)
        Shared.Book.{ id; name }
      in
      let books = List.map to_book books in
      let to_json = yojson_of_list Shared.Book.yojson_of_t in
      Dream.json @@ Yojson.Safe.to_string (to_json books)
    ;;
  end
end

let go () =
  Dream.run
  @@ Dream.logger
  @@ Dream.sql_pool (Repo.Init.get_uri ())
  @@ Dream.router
       [ Dream.get "/" Handler.root
       ; Dream.get "/books" Handler.Book.get_all
       ; Dream.get "/echo/:word" (fun req -> Handler.echo (Dream.param req "word"))
       ]
;;
