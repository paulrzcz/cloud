module Random
    ( getRandomMessage
    ) where

import           System.Random.Mersenne.Pure64

import           Message

getRandomMessage :: PureMT -> (Message, PureMT)
getRandomMessage gen = (Message msg, newGen)
  where
    (msg, newGen) = randomDouble gen
