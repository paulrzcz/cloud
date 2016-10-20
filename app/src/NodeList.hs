{-# LANGUAGE OverloadedStrings #-}
module NodeList
    ( activeNodes
    ) where

import           Control.Distributed.Process (NodeId (..), ProcessId)
import qualified Data.ByteString.Char8       as BS
import           Network.Socket              (HostName, ServiceName)
import           Network.Transport           (EndPointAddress (..))

-- we will keep here the node list

activeNodes :: [NodeId]
activeNodes = map mkNodeId nodes

mkNodeId :: (HostName, ServiceName) -> NodeId
mkNodeId (host, srv) = NodeId . EndPointAddress . BS.concat $ [BS.pack host, ":", BS.pack srv, ":0"]

nodes :: [(HostName, ServiceName)]
nodes = [("10.0.1.12", "4001"), ("10.0.1.12", "4002")]
