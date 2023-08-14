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
      (* This handler uses the Dream SQL pool *)
      let%lwt books = Dream.sql req (or_fail Repo.Book.ls) in
      Dream.html @@ Printf.sprintf "Books count: %d" (List.length books)
    ;;

    let get_all2 pool _req =
      (* This handler uses a custom pool, and handles errors manually.
         (an HTTP 400 status (Bad Request) + a custom body is returned on failure) *)
      let%lwt res = Caqti_lwt.Pool.use Repo.Book.ls pool in
      match res with
      | Error err ->
        let err = Caqti_error.show err in
        let () = Dream.log "Got a Caqti error: %s" err in
        Dream.html ?status:(Some `Bad_Request) "Oops, something went wrong!"
      | Ok v -> Dream.html (Printf.sprintf "Books2 count: %d" (List.length v))
    ;;

    let get_all3 conn _req =
      (* This handler uses a custom pool, but behaves in a similar way to Dream's default.
         (an HTTP 500 will be returned on failure) *)
      let%lwt books = or_fail (Caqti_lwt.Pool.use Repo.Book.ls) conn in
      Dream.html @@ Printf.sprintf "Books3 count: %d" (List.length books)
    ;;
  end
end

let run
  (pool :
    ((module Caqti_lwt.CONNECTION), [> Caqti_error.call_or_retrieve ]) Caqti_lwt.Pool.t)
  =
  Dream.run
  @@ Dream.logger
  @@ Dream.sql_pool (Repo.Init.get_uri ())
  @@ Dream.router
       [ Dream.get "/" Handler.root
       ; Dream.get "/books" Handler.Book.get_all
       ; Dream.get "/books2" (Handler.Book.get_all2 pool)
       ; Dream.get "/books3" (Handler.Book.get_all3 pool)
       ; Dream.get "/echo/:word" (fun req -> Handler.echo (Dream.param req "word"))
       ]
;;
