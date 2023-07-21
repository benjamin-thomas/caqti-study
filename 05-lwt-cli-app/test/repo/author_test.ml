module Author = Repo.Author

let str_error = Utils.str_error

let%test_unit "count returns 0, when there are no rows" =
  let ( => ) = [%test_eq: (Base.int, Base.string) Base.Result.t] in
  let prom =
    let open Lwt_result.Syntax in
    let* conn = Setup.fresh_db () |> str_error in
    Author.count conn () |> str_error
  in

  Lwt_main.run prom => Ok 0

let%test_unit "count returns 1, after inserting Jane" =
  let ( => ) = [%test_eq: (Base.int, Base.string) Base.Result.t] in
  let prom =
    let open Lwt_result.Syntax in
    let* conn = Setup.fresh_db () in
    let* () =
      Author.insert conn
        { first_name = "Jane"; middle_name = None; last_name = "Doe" }
    in

    Author.count conn ()
  in

  Lwt_main.run (str_error prom) => Ok 1

let%test_unit "find_by_id, terser" =
  let ( => ) = [%test_eq: (Base.string, Base.string) Base.Result.t] in
  let prom =
    let open Lwt_result.Syntax in
    let* conn = Setup.fresh_db () in
    let* () =
      Author.insert conn
        { first_name = "John"; middle_name = None; last_name = "Doe" }
    in
    Author.find_by_id conn 1
  in
  Lwt_main.run (str_error prom) => Ok "John"

let%test_unit "read many" =
  let ( => ) = [%test_eq: (Base.string Base.list, Base.string) Base.Result.t] in

  let prom =
    let open Lwt_result.Syntax in
    let* conn = Setup.fresh_db () in
    let* () =
      Author.insert conn
        { first_name = "John"; middle_name = None; last_name = "Doe" }
    in
    let* () =
      Author.insert conn
        { first_name = "Jane"; middle_name = None; last_name = "Doe" }
    in
    Author.ls conn ()
  in
  Lwt_main.run (str_error prom) => Ok [ "John"; "Jane" ]
