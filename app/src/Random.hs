module Random
    ( getRandomMessage
    ) where

import           System.Random.Mersenne.Pure64

import           Message                       (Payload (..))

getRandomMessage :: PureMT -> (Payload, PureMT)
getRandomMessage gen = (Payload msg, newGen)
  where
    (msg, newGen) = randomDouble gen -- there is a concern if it generates (0,1] or [0,1]
