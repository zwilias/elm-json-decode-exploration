# POC: Elm JSON decoders as functions

In Elm, a JSON decoder is not, and does not behave like, a function. This is counterintuitive, not strictly necessary, and leads to very real bugs relating to recursive decoders.

It helps, in teaching, to think about decoders as having the following type: `type alias Decoder a = Json.Decode.Value -> Result String a`. This repo is a reality check - can `Json.Decode` be implemented with that exact type alias?
