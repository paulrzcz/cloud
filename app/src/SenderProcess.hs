{-# LANGUAGE DeriveDataTypeable #-}
module SenderProcess
    ( senderProcess
    ) where

import           Data.Data
import           Data.Int
import           Data.Typeable

import           Control.Applicative
import           Control.Distributed.Process
import           Control.Distributed.Process.Extras.Time  (TimeUnit (..),
                                                           within)
import           Control.Distributed.Process.Extras.Timer (exitAfter)
import           Control.Distributed.Process.Serializable
import           Control.Monad
import           System.Random.Mersenne.Pure64

import           Random

senderProcess :: Int -> PureMT -> [ProcessId] -> Process ()
senderProcess timeToLive rng allProcesses = do
    pid <- getSelfPid
    register "sender" pid
    exitAfter (within timeToLive Seconds) pid "Time to kill sending process"
    go rng
    return ()
  where
    go :: PureMT -> Process ()
    go rng' = do
      _ <- receiveTimeout 0 []
      foldM sendToPid rng' allProcesses >>= go

    sendToPid :: PureMT -> ProcessId -> Process PureMT
    sendToPid r pid = do
      let (m, r') = getRandomMessage r
      send pid m
      return r'
