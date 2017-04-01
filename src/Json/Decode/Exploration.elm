module Json.Decode.Exploration exposing (..)

import Json.Encode
import Native.Json


type alias Value =
    Json.Encode.Value


type alias Decoder a =
    Value -> Result String a


int : Decoder Int
int =
    Native.Json.intDecoder


bool : Decoder Bool
bool =
    Native.Json.boolDecoder


string : Decoder String
string =
    Native.Json.stringDecoder


float : Decoder Float
float =
    Native.Json.floatDecoder


nullable : Decoder a -> Decoder (Maybe a)
nullable aDecoder =
    \value ->
        aDecoder value |> Result.toMaybe |> Result.Ok


constant : a -> Decoder a
constant =
    Native.Json.constantDecoder


null : a -> Decoder a
null a =
    Native.Json.nullDecoder a


list : Decoder a -> Decoder (List a)
list a =
    Native.Json.listDecoder a


field : String -> Decoder a -> Decoder a
field name a =
    Native.Json.field name a


lazy : (() -> Decoder a) -> Decoder a
lazy f =
    value
        >> Result.andThen (\v -> f () v)


map2 : (a -> b -> c) -> Decoder a -> Decoder b -> Decoder c
map2 f aDecoder bDecoder =
    \value ->
        Result.map2 f
            (aDecoder value)
            (bDecoder value)


decodeValue : Value -> Decoder a -> Result String a
decodeValue value aDecoder =
    aDecoder value


oneOf : List (Decoder a) -> Decoder a
oneOf =
    Native.Json.oneOf



--
-- array : Decoder a -> Decoder (Array a)
-- array aDecoder =
--     _
--
-- dict : Decoder a -> Decoder (Dict String a)
-- dict aDecoder =
--     _
--
-- keyValuePairs : Decoder a -> Decoder (List (String, a))
-- keyValuePairs aDecoder =
--     _


value : Decoder Value
value =
    Result.Ok
