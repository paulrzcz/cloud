{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric      #-}
module Message
    ( Payload(..)
    , ResultState (..)
    , updateResult
    , initialState
    , SwitchToFinalization (..)
    ) where

import           Control.DeepSeq                          (NFData)
import           Control.Distributed.Process.Serializable
import           Data.Binary                              (Binary (..))
import           Data.Data
import           Data.Typeable
import           GHC.Generics


data Payload = Payload Double deriving (Show, Typeable, Data, Generic)
instance Binary Payload

data SwitchToFinalization = SwitchToFinalization deriving (Show, Typeable, Data, Generic)
instance Binary SwitchToFinalization
instance NFData SwitchToFinalization

--
data ResultState = ResultState Integer Double deriving (Show, Eq)

initialState = ResultState 0 0.0

updateResult :: ResultState -> Payload -> ResultState
updateResult (ResultState n value) (Payload newValue) =
  let newN = n + 1
  in ResultState newN (value + (fromIntegral newN) * newValue)
