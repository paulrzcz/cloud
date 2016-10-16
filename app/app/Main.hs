{-# LANGUAGE OverloadedStrings #-}
module Main where

import           CmdArgs

import           Control.Distributed.Process.Backend.SimpleLocalnet
import qualified Control.Distributed.Process.Node                   as N

import           Control.Monad.Logger
import           Control.Monad.Trans.Class

import           Data.Text                                          (pack)

main :: IO ()
main = runStderrLoggingT $ do
  logDebugN "Starting..."
  args <- lift getCloudArgs
  logDebugN $ pack $ show args

  -- init backend
  logDebugN "Initializing backend..."
  backend <- lift $ initializeBackend (hostName args) (portNum args) N.initRemoteTable
  logDebugN "SimpleLocalnet backend is initialized"

  -- spin off sending process that should be active no more than send-for time

  -- spin off receiving process that should calculate the tuple

  logDebugN "Quit!"
  return ()
