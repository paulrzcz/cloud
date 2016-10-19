module NodeList
    ( activeNodes
    ) where

import           Control.Distributed.Process                        (ProcessId)
import           Network.Socket                                     (HostName,
                                                                     ServiceName)

import           Control.Distributed.Process.Backend.SimpleLocalnet (Backend)

-- we will keep here the node list

activeNodes :: Backend -> [ProcessId]
activeNodes = undefined


nodes :: [(HostName, ServiceName)]
nodes = [("127.0.0.1", "4000")]
