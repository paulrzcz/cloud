{-# LANGUAGE DeriveDataTypeable #-}
module Message
    ( Message(..)
    , ResultState (..)
    , updateResult
    ) where

import           Control.Distributed.Process.Serializable
import           Data.Binary                              (Binary (..))
import           Data.Data
import           Data.Typeable

data Message = Message Double deriving (Show, Typeable, Data)

instance Binary Message where
  put (Message msg) = put msg
  get = Message <$> get

-- the object sending across the network should implement Serializable
instance Serializable Message

--
data ResultState = ResultState Integer Double

initialState = ResultState 0 0.0

updateResult :: ResultState -> Message -> ResultState
updateResult (ResultState n value) (Message newValue) =
  let newN = n + 1
  in ResultState newN (value + (fromIntegral newN) * newValue)
