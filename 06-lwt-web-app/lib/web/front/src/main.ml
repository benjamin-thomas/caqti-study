module H = Fmlib_browser.Html
module A = Fmlib_browser.Attribute
module Cmd = Fmlib_browser.Command
module Task = Fmlib_browser.Task
module Decoder = Fmlib_browser.Decoder
module Sub = Fmlib_browser.Subscription

(*
 * MODEL
 *)

type model =
  | NotAsked
  | Loading
  | Loaded of Shared.Book.t list
  | Failed of string

(*
 * DECODERS
 *)

let book_decoder : Shared.Book.t Decoder.t =
  Decoder.(
    let* id = field "id" int in
    let* name = field "name" string in
    return Shared.Book.{ id; name })
;;

(*
 * UPDATE
 *)

type msg =
  | FetchBtnClicked
  | GotJson of (Shared.Book.t array, Task.http_error) result
  | StartOverBtnClicked

let fetch_books : msg Cmd.t =
  let ( >>= ) = Task.( >>= ) in
  let fetch : (Shared.Book.t array, Task.http_error) Task.t =
    Task.sleep 1000 ()
    >>= fun () ->
    let headers = [] in
    let body = "" in
    Task.http_json
      "GET"
      "http://localhost:8080/books"
      headers
      body
      (Decoder.array book_decoder)
  in
  Cmd.attempt (fun res -> GotJson res) fetch
;;

let string_of_http_error : Task.http_error -> string = function
  | `Http_status n -> Printf.sprintf "HTTP status code: %d" n
  | `Http_no_json -> "Oops, I did not receive JSON!"
  | `Http_decode -> "Oops, got a decode error!"
;;

let update (_ : model) (msg : msg) : model * msg Cmd.t =
  match msg with
  | FetchBtnClicked -> (Loading, fetch_books)
  | GotJson (Ok books) -> (Loaded (Array.to_list books), Cmd.none)
  | GotJson (Error err) -> (Failed (string_of_http_error err), Cmd.none)
  | StartOverBtnClicked -> (NotAsked, Cmd.none)
;;

(*
 * VIEW
 *)

let view (model : model) : msg H.t =
  let to_li (b : Shared.Book.t) = H.li [] [ H.text b.name ] in
  H.div
    []
    [ H.h1 [] [ H.text "List of books" ]
    ; H.div
        []
        (match model with
         | NotAsked ->
           [ H.p [] [ H.text "Hello user! Do press that button!" ]
           ; H.div
               [ A.on_click FetchBtnClicked ]
               [ H.button [] [ H.text "Fetch the books!" ] ]
           ]
         | Loading -> [ H.text "Loading..." ]
         | Failed err_str ->
           [ H.div [] [ H.text @@ "Oops, I got an error :(" ]
           ; H.p [] [ H.text err_str ]
           ; H.div [] [ H.button [ A.on_click FetchBtnClicked ] [ H.text "Try again?" ] ]
           ]
         | Loaded books ->
           [ H.ul [] (List.map to_li books)
           ; H.div
               []
               [ H.button [ A.on_click StartOverBtnClicked ] [ H.text "Start over?" ] ]
           ])
    ]
;;

(*
 * BOOTSTRAP
 *)

let sub _model = Sub.none
let init = Decoder.return (NotAsked, Cmd.none)
let () = Fmlib_browser.element "my_app" init view sub update
