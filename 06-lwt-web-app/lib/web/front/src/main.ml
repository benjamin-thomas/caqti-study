module H = Fmlib_browser.Html
module A = Fmlib_browser.Attribute

(*
 * MODEL
 *)

type model =
  { counter : int
  ; book : Shared.Book.t
  }

let init = { counter = 0; book = { id = 1; name = "Hello" } }

(*
 * UPDATE
 *)

type msg = Inc

let update (model : model) (msg : msg) =
  match msg with
  | Inc -> { model with counter = model.counter + 1 }
;;

(*
 * VIEW
 *)

let disabled b : 'msg A.t =
  if b then
    A.attribute "disabled" ""
  else
    (* bogus name: it doesn't look like I can return a NOOP attribute at the moment *)
    A.attribute "disabled_" ""
;;

let view (model : model) =
  H.div
    []
    [ H.h1 [] [ H.text "Counter example" ]
    ; H.div
        []
        [ H.input [ A.value (string_of_int model.counter); disabled true ] []
        ; H.button [ A.on_click Inc ] [ H.text "count" ]
        ]
    ; H.h2 [] [ H.text "Book details" ]
    ; H.div
        []
        [ H.h3 [] [ H.text "Title 4" ]
        ; H.p [] [ H.text model.book.name ]
        ; H.text "ID"
        ; H.p [] [ H.text (string_of_int model.book.id) ]
        ]
    ]
;;

(*
 * BOOTSTRAP
 *)

let () = Fmlib_browser.sandbox init view update
