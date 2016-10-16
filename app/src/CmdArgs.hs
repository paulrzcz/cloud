{-# LANGUAGE DeriveDataTypeable #-}
module CmdArgs
    ( cloudArgs
    , Config
    , getCloudArgs
    ) where

import           Data.Data
import           Data.Typeable

import           System.Console.CmdArgs

data Config = Config {
  sendTime :: Int,
  waitTime :: Int,
  seedNum  :: Int
} deriving (Show, Data, Typeable)

cloudArgs = Config {
  sendTime = 5 &= help "Time to send messages" &= explicit &= name "send-time" &= opt (5 :: Int),
  waitTime = 10 &= help "Time to wait for messages" &= explicit &= name "wait-time" &= opt (10 :: Int),
  seedNum  = 1 &= help "RNG seed" &= explicit &= name "with-seed" &= opt (1 :: Int)
} &= summary "Cloud test v 0.1.0.0"
  &= program "app"

getCloudArgs = cmdArgs cloudArgs
