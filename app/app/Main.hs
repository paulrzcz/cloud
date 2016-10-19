{-# LANGUAGE OverloadedStrings #-}
module Main where

import           CmdArgs
import           SenderProcess

import           Control.Distributed.Process
import qualified Control.Distributed.Process.Node         as N
import           Control.Distributed.Process.Serializable

import           Control.Concurrent                       (threadDelay)
import           Control.Exception                        (throw)
import           Control.Monad.Logger                     (logDebugN,
                                                           runStderrLoggingT)
import           Control.Monad.Trans.Class

import           Data.Text                                (Text, pack)
import           Data.Typeable

import qualified Network.Transport.TCP                    as NT

import           System.Random.Mersenne.Pure64

main :: IO ()
main = runStderrLoggingT $ do
  logDebugN "Starting..."
  args <- lift getCloudArgs
  logDebugN $ pack $ show args

  -- init backend
  logDebugN "Initializing transport..."
  eitherTransport <- lift $ NT.createTransport (hostName args) (portNum args) NT.defaultTCPParameters
  node <- case eitherTransport of
    Left err -> throw err
    Right transport -> lift $ N.newLocalNode transport N.initRemoteTable
  logDebugN "Node is initialized"

  _ <- lift $ N.runProcess node $ do
    self <- getSelfPid
    send self ( "hello" :: String)
    hello <- expect :: Process String
    say hello
    liftIO $ threadDelay 1000
    return ()

  -- spin off sending process that should be active no more than send-for time
  let rng = pureMT (seedNum args)
  _<- lift $ N.runProcess node $ senderProcess (sendTime args) rng []

  -- spin off receiving process that should calculate the tuple

  logDebugN "Quit!"
  return ()
