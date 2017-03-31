module Tests exposing (..)

import Test exposing (..)
import Expect
import Json.Encode
import Json.Decode.Exploration as DE


intVal : Json.Encode.Value
intVal =
    Json.Encode.int 5


boolVal : Json.Encode.Value
boolVal =
    Json.Encode.bool True


all : Test
all =
    describe "int"
        [ test "it can decode an integer" <|
            \() ->
                DE.int intVal
                    |> Expect.equal (Result.Ok 5)
        , test "it cannot decode a bool" <|
            \() ->
                DE.int boolVal
                    |> Expect.equal (Result.Err "")
        ]
