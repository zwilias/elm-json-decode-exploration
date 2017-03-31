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

list : Decoder a -> Decoder (List a)
list aDecoder =
    _

array : Decoder a -> Decoder (Array a)
array aDecoder =
    _

dict : Decoder a -> Decoder (Dict String a)
dict aDecoder =
    _

keyValuePairs : Decoder a -> Decoder (List (String, a))
keyValuePairs aDecoder =
    _

value : Decoder Value
value =
    identity |> Result.Ok
