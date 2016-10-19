{-# LANGUAGE OverloadedStrings #-}
module Main where

import           CmdArgs
import           SenderProcess

import           Control.Distributed.Process
import           Control.Distributed.Process.Backend.SimpleLocalnet
import qualified Control.Distributed.Process.Node                   as N
import           Control.Distributed.Process.Serializable

import           Control.Concurrent                                 (threadDelay)
import           Control.Monad.Logger
import           Control.Monad.Trans.Class

import           Data.Text                                          (Text, pack)
import           Data.Typeable

import           System.Random.Mersenne.Pure64

main :: IO ()
main = runStderrLoggingT $ do
  logDebugN "Starting..."
  args <- lift getCloudArgs
  logDebugN $ pack $ show args

  -- init backend
  logDebugN "Initializing backend..."
  backend <- lift $ initializeBackend (hostName args) (portNum args) N.initRemoteTable
  logDebugN "SimpleLocalnet backend is initialized"
  node <- lift $ newLocalNode backend

  _ <- lift $ N.runProcess node $ do
    self <- getSelfPid
    send self ( "hello" :: String)
    hello <- expect :: Process String
    say hello
    liftIO $ threadDelay 1000
    return ()

  -- spin off sending process that should be active no more than send-for time
  let rng = pureMT (seedNum args)
  _<- lift $ N.runProcess node $ senderProcess rng []

  -- spin off receiving process that should calculate the tuple

  logDebugN "Quit!"
  return ()
