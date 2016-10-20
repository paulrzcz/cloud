module Random
    ( getRandomMessage
    ) where

import           System.Random.Mersenne.Pure64

import           Message                       (Payload (..))

-- random should be (0, 1]
randomHalfClosed :: PureMT -> (Double, PureMT)
randomHalfClosed g = (fromIntegral (1 + i `div` 2048) / 9007199254740993, g')
        where (i, g') = randomWord64 g

getRandomMessage :: PureMT -> (Payload, PureMT)
getRandomMessage gen = (Payload msg, newGen)
  where
    (msg, newGen) = randomHalfClosed gen
