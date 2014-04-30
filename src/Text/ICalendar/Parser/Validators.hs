module Text.ICalendar.Parser.Validators where

import            Data.Char (toUpper)
import qualified  Data.HashMap.Lazy   as H
import            Text.Parsec.Error
import            Text.Parsec.Pos

import Text.ICalendar.Parser.Combinators

opt1 :: String -> ICalTree -> Either ParseError (Maybe String)
opt1 node tree =
  case H.lookup (upcase node) tree of
    Just (Property [x] _) -> Right $ Just x
    Nothing               -> Right Nothing
    x                     -> possibleErrors node x

optN :: String -> ICalTree -> Either ParseError [String]
optN node tree =
  case H.lookup (upcase node) tree of
    Just (Property x _) -> Right x
    Nothing             -> Right []
    x                   -> possibleErrors node x

req1 :: String -> ICalTree -> Either ParseError String
req1 node tree =
  case H.lookup (upcase node) tree of
    Just (Property [x] _) -> Right x
    x                     -> possibleErrors node x

reqN :: String -> ICalTree -> Either ParseError [String]
reqN node tree =
  case H.lookup (upcase node) tree of
    Just (Property all@(x:xs) _)  -> Right all
    x                             -> possibleErrors node x

-- private functions

possibleErrors :: String -> Maybe ICalParam -> Either ParseError a
possibleErrors node value =
  case value of
    -- this error position should be the openning line of the containing component
    Nothing                 -> err (initialPos "Unknown") "must be assigned at least once"
    Just (Property _ pos)   -> err pos "cannot be assigned more than once"
    Just (Component _ pos)  -> err pos "is expected to be a property"
  where
    err pos msg = Left $ newErrorMessage (Message $ node ++ msg) pos

upcase :: String -> String
upcase = map toUpper
