{-# LANGUAGE DeriveDataTypeable #-}
module CmdArgs
    ( cloudArgs
    , Config (..)
    , getCloudArgs
    ) where

import           Data.Data
import           Data.Typeable
import           Data.Word
import           Network.Socket         (HostName, ServiceName)
import           System.Console.CmdArgs

data Config = Config {
  sendTime :: Int,
  waitTime :: Int,
  seedNum  :: Word64,
  hostName :: HostName,
  portNum  :: ServiceName
} deriving (Show, Data, Typeable)

cloudArgs = Config {
  sendTime = 5 &= help "Time to send messages" &= explicit &= name "send-for" &= opt (5 :: Int),
  waitTime = 10 &= help "Time to wait for messages" &= explicit &= name "wait-for" &= opt (10 :: Int),
  seedNum  = 1 &= help "RNG seed" &= explicit &= name "with-seed" &= opt (1 :: Int),
  hostName = def &= help "Node host name" &= explicit &= name "host",
  portNum = def &= help "Node port number" &= explicit &= name "port"
} &= summary "CloudHaskell test v 0.1.0.0"
  &= program "app"

getCloudArgs = cmdArgs cloudArgs
