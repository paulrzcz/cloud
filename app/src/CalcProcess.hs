module CalcProcess
    ( calcProcess
    ) where

import           Message

import           Control.Distributed.Process
import           Control.Distributed.Process.Extras.Time  (TimeUnit (..),
                                                           within)
import           Control.Distributed.Process.Extras.Timer (exitAfter)

calcProcess :: Int -> Process ()
calcProcess timeout = do
    pid <- getSelfPid
    register "calc" pid
    exitAfter (within timeout Seconds) pid "It is time to die"
    go
  where
    go = undefined
