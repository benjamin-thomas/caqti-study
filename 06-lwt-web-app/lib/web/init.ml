module Handler = struct
  let root _ = Dream.html "Hello, world!"
  let echo word = Dream.html (Printf.sprintf "echo is -> %s" word)

  (** Conforms to Dream's expectations *)
  let or_fail f conn =
    let%lwt result = f conn in
    Caqti_lwt.or_fail result
  ;;

  module Book = struct
    let get_all req =
      let%lwt books = Dream.sql req (or_fail Repo.Book.ls) in
      Dream.html (Printf.sprintf "Books count: %d" (List.length books))
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
