module Text.ICalendar.DataType.DurationSpec
( main
, spec
) where

import Data.Time.Clock
import qualified Text.Parsec.Prim as P
import Text.Parsec.Error
import Test.Hspec

import SpecHelper
import Text.ICalendar.DataType.Duration

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
  describe "toDuration" $ do
    describe "parsing a date-formatted duration" $ do
      it "parses days" $ do
        parse "P1DT0H0M0S" `shouldBe` diffTime 86400
      it "parses hours" $ do
        parse "P0DT1H0M0S" `shouldBe` diffTime 3600
      it "parses minutes" $ do
        parse "P0DT0H1M0S" `shouldBe` diffTime 60
      it "parses seconds" $ do
        parse "P0DT0H0M1S" `shouldBe` diffTime 1
    describe "parsing a time-formatted duration" $ do
      it "parses hours" $ do
        parse "PT1H0M0S" `shouldBe` diffTime 3600
      it "parses minutes" $ do
        parse "PT0H1M0S" `shouldBe` diffTime 60
      it "parses seconds" $ do
        parse "PT0H0M1S" `shouldBe` diffTime 1
    describe "parsing a week-formatted duration" $ do
      it "parses weeks" $ do
        parse "P1W" `shouldBe` diffTime 604800

-- private functions

parse :: String -> Either ParseError DiffTime
parse = P.parse toDuration "duration"

diffTime :: Integer -> Either a DiffTime
diffTime = Right . secondsToDiffTime
