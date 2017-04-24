module Connection.Models exposing (..)
import Dict exposing (..)

type ModalState
    = Hide
    | Show

type LoadState a = 
    NotLoaded 
    | Loading a
    | Loaded a


emptyDictIfNotLoaded : LoadState (Dict a b) -> Dict a b
emptyDictIfNotLoaded loadStateEntity =
    case loadStateEntity of
        NotLoaded -> Dict.empty
        Loading previous -> previous
        Loaded dict -> dict

emptyListIfNotLoaded : LoadState(List a) -> List a
emptyListIfNotLoaded loadStateEntity =
    case loadStateEntity of
        NotLoaded -> []
        Loading previous -> previous
        Loaded list -> list