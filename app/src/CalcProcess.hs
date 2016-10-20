module CalcProcess
    ( calcProcess
    ) where

import           Message

import           Control.Distributed.Process
import           Control.Distributed.Process.Extras.Time  (TimeUnit (..),
                                                           within)
import           Control.Distributed.Process.Extras.Timer (exitAfter, sendAfter)

calcProcess :: Int -> Int -> ResultState -> Process ()
calcProcess killTimeout sendTimeout state = do
    pid <- getSelfPid
    register "calc" pid
    exitAfter (within killTimeout Seconds) pid "It is time to die"
    sendAfter (within sendTimeout Seconds) pid SwitchToFinalization
    go state
  where
    go st = do
      msg <- receiveWait [
          match (\x@(Payload _) -> return $ Just x),
          match (\SwitchToFinalization -> return Nothing)
        ]
      case msg of
        Nothing -> goFinal st
        Just m -> do
                    let newState = updateResult st m
                    go newState
    goFinal st = do
      msg <- receiveTimeout 10 [
          match (\x@(Payload _) -> return x)
        ]
      case msg of
        Nothing -> say $ show st
        Just m -> do
                    let newState = updateResult st m
                    goFinal newState
