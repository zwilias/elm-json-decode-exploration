module Tests exposing (..)

import Test exposing (..)
import Expect
import Json.Encode
import Json.Decode.Exploration as DE


type Node
    = IntNode Int (List Node)
    | StringNode String (List Node)


type alias SimpleRecord =
    { a : String, b : String }


intNodeDecoder : DE.Decoder Node
intNodeDecoder =
    DE.map2 IntNode
        (DE.field "val" DE.int)
        (DE.field "children" (DE.list (DE.lazy (\_ -> nodeDecoder))))


stringNodeDecoder : DE.Decoder Node
stringNodeDecoder =
    DE.map2 StringNode
        (DE.field "val" DE.string)
        (DE.field "children" (DE.list (DE.lazy (\_ -> nodeDecoder))))


nodeDecoder : DE.Decoder Node
nodeDecoder =
    DE.oneOf
        [ DE.lazy (\_ -> intNodeDecoder)
        , DE.lazy (\_ -> stringNodeDecoder)
        ]


intVal : Json.Encode.Value
intVal =
    Json.Encode.int 5


boolVal : Json.Encode.Value
boolVal =
    Json.Encode.bool True


listOfInt : Json.Encode.Value
listOfInt =
    List.range 1 5
        |> List.map Json.Encode.int
        |> Json.Encode.list


object : Json.Encode.Value
object =
    Json.Encode.object []


simpleObject : Json.Encode.Value
simpleObject =
    Json.Encode.object [ ( "foo", (Json.Encode.string "bar") ) ]


all : Test
all =
    describe "base decoders"
        [ describe "int"
            [ test "it can decode an integer" <|
                \() ->
                    DE.decodeValue intVal DE.int
                        |> Expect.equal (Result.Ok 5)
            , test "it cannot decode a bool" <|
                \() ->
                    DE.decodeValue boolVal DE.int
                        |> Expect.equal
                            (Result.Err
                                "Expected an Int but instead got: true"
                            )
            ]
        , describe "list"
            [ test "it can decode a list of ints" <|
                \() ->
                    DE.decodeValue listOfInt (DE.list DE.int)
                        |> Expect.equal
                            (Result.Ok [ 1, 2, 3, 4, 5 ])
            ]
        , test "field" <|
            \() ->
                DE.decodeValue simpleObject (DE.field "foo" DE.string)
                    |> Expect.equal (Ok "bar")
        , test "map2" <|
            \() ->
                DE.decodeValue (Json.Encode.string "foo") (DE.map2 SimpleRecord DE.string DE.string)
                    |> Expect.equal (Ok <| SimpleRecord "foo" "foo")
        , test "nodeDecoder" <|
            \() ->
                DE.decodeValue object nodeDecoder
                    |> Expect.equal (Result.Err "oneOf failed to find successful decoder: Expected an object with a field named `val` but instead got: {}; Expected an object with a field named `val` but instead got: {}")
        ]
