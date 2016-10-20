{-# LANGUAGE OverloadedStrings #-}
module Main where

import           CalcProcess
import           CmdArgs
import           NodeList
import           SenderProcess

import           Control.Distributed.Process
import qualified Control.Distributed.Process.Node         as N
import           Control.Distributed.Process.Serializable

import           Control.Concurrent                       (threadDelay)
import           Control.Exception                        (throw)
import           Control.Monad.Logger                     (logDebugN,
                                                           runStderrLoggingT)
import           Control.Monad.Trans.Class

import           Data.List                                (delete)
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


  lift $ N.runProcess node $ do
    -- spin off sending process that should be active no more than send-for time
    let rng = pureMT (seedNum args)
    senderPid <- spawnLocal $ senderProcess (sendTime args) rng activeNodes
    senderRef <- monitor senderPid
      -- spin off receiving process that should calculate the tuple
    calcPid <- spawnLocal $ calcProcess (sendTime args + waitTime args)
    calcRef <- monitor calcPid

    waitAllToDie [senderRef, calcRef]
    return ()


  logDebugN "Quit!"
  lift $ threadDelay 1000 -- let us get 1 sec for all processes to say something
  return ()

--

waitAllToDie :: [MonitorRef] -> Process ()
waitAllToDie [] = return ()
waitAllToDie xs = do
  say $ concat ["There were ", show $ length xs, " in the bed"]
  newXs <- receiveWait [
      matchIf (\(ProcessMonitorNotification ref _ _) -> elem ref xs)
        (\(ProcessMonitorNotification ref _ _) -> do
            say "one fell out"
            say ("Process has died : " ++ show ref)
            return $ delete ref xs)
    ]
  waitAllToDie newXs
