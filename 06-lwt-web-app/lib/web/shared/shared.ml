open Ppx_yojson_conv_lib.Yojson_conv.Primitives

module Book = struct
  type t =
    { id : int
    ; name : string
    }
  [@@deriving yojson]
end
