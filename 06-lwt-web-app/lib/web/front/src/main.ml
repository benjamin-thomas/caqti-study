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
  | Not_asked
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
  | Fetch_btn_clicked
  | Got_json of (Shared.Book.t array, Task.http_error) result
  | Start_over_btn_clicked

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
  Cmd.attempt (fun res -> Got_json res) fetch
;;

let string_of_http_error : Task.http_error -> string = function
  | `Http_status n -> Printf.sprintf "HTTP status code: %d" n
  | `Http_no_json -> "Oops, I did not receive JSON!"
  | `Http_decode -> "Oops, got a decode error!"
;;

let update (_ : model) (msg : msg) : model * msg Cmd.t =
  match msg with
  | Fetch_btn_clicked -> (Loading, fetch_books)
  | Got_json (Ok books) -> (Loaded (Array.to_list books), Cmd.none)
  | Got_json (Error err) -> (Failed (string_of_http_error err), Cmd.none)
  | Start_over_btn_clicked -> (Not_asked, Cmd.none)
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
         | Not_asked ->
           [ H.p [] [ H.text "Hello user! Do press that button!" ]
           ; H.div
               [ A.on_click Fetch_btn_clicked ]
               [ H.button [] [ H.text "Fetch the books!" ] ]
           ]
         | Loading -> [ H.text "Loading..." ]
         | Failed err_str ->
           [ H.div [] [ H.text @@ "Oops, I got an error :(" ]
           ; H.p [] [ H.text err_str ]
           ; H.div
               []
               [ H.button [ A.on_click Fetch_btn_clicked ] [ H.text "Try again?" ] ]
           ]
         | Loaded books ->
           [ H.ul [] (List.map to_li books)
           ; H.div
               []
               [ H.button [ A.on_click Start_over_btn_clicked ] [ H.text "Start over?" ] ]
           ])
    ]
;;

(*
 * BOOTSTRAP
 *)

let sub _model = Sub.none
let init = Decoder.return (Not_asked, Cmd.none)
let () = Fmlib_browser.element "my_app" init view sub update
