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

senderProcess :: Int -> PureMT -> [NodeId] -> Process ()
senderProcess timeToLive rng allProcesses = do
    pid <- getSelfPid
    register "sender" pid
    exitAfter (within timeToLive Seconds) pid "Time to kill sending process"
    go rng
    return ()
  where
    go :: PureMT -> Process ()
    go rng' = do
      _ <- receiveTimeout 0 [] -- for catching exit signal
      foldM sendToPid rng' allProcesses >>= go

    sendToPid :: PureMT -> NodeId -> Process PureMT
    sendToPid r node = do
      let (m, r') = getRandomMessage r
      nsend "calc" m
      return r'
