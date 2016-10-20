module Main where

import           Test.Hspec
import           Test.QuickCheck.Monadic

import           Control.Monad.Trans.Class

import           Message
import           Random
import           System.Random.Mersenne.Pure64

main :: IO ()
main = hspec $ do
  describe "Result update tests" $ do
    it "Adding the first message with 0.5" $
      updateResult initialState (Payload 0.5) `shouldBe` (ResultState 1 0.5)
    it "Adding the second message with 0.5" $
      updateResult (ResultState 1 0.5) (Payload 0.5) `shouldBe` (ResultState 2 1.5)
  describe "Random generator property test" $ do
    it "No zero components in random generator (probabilistic)" $ do
      monadicIO $ do
        rng <- lift newPureMT
        let (Payload x, _) = getRandomMessage rng
        return $ x > 0.0
