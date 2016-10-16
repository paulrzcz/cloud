module Main where

import           Test.Hspec
import           Test.QuickCheck

import           Message

main :: IO ()
main = hspec $ do
  describe "Result update tests" $ do
    it "Adding the first message with 0.5" $
      updateResult initialState (Message 0.5) `shouldBe` (ResultState 1 0.5)
