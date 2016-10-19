{-# LANGUAGE DeriveDataTypeable #-}
module SenderProcess
    (
    ) where

import           Data.Data
import           Data.Int
import           Data.Typeable

import           Control.Applicative
import           Control.Distributed.Process
import           Control.Distributed.Process.Serializable
import           Control.Monad
import           Data.Binary                              (Binary (..), Get)
import           System.Random.Mersenne.Pure64

import           Random

data CalculationPayload a = Task a
  | FinishCalculation
  deriving (Show, Eq, Typeable, Data)

instance Binary a => Binary (CalculationPayload a) where
  put FinishCalculation = put (0 :: Int32)
  put (Task a) = do
    put (1 :: Int32)
    put a
  get = do
    s <- get :: Get Int32
    case s of
      0 -> return FinishCalculation
      1 -> Task <$> get
      _ -> fail "Incorrect type of CalculationPayload!"

-- instance Serializable a => Serializable (CalculationPayload a)

senderProcess :: PureMT -> [ProcessId] -> Process ()
senderProcess rng allProcesses = do
  let (m, rng') = getRandomMessage rng
  forM_ allProcesses $ \pid -> send pid (Task m)
