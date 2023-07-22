module Book = Repo.Book

let str_error = Utils.str_error

let%test_unit "count returns 0, when there are no rows" =
  let ( => ) = [%test_eq: (Base.int, Base.string) Base.Result.t] in
  let prom =
    let open Lwt_result.Syntax in
    let* conn = Setup.fresh_db () in
    Book.count conn
  in
  Lwt_main.run (str_error prom) => Ok 0

let%test_unit "count returns 1, after inserting OFTVB" =
  let ( => ) = [%test_eq: (Base.int, Base.string) Base.Result.t] in
  let prom =
    let open Lwt_result.Syntax in
    let* conn = Setup.fresh_db () in
    let* () = Book.insert conn { title = "OCaml from the Very Beginning" } in
    Book.count conn
  in
  Lwt_main.run (str_error prom) => Ok 1
