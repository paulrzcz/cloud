{-# LANGUAGE DeriveDataTypeable #-}
module Message
    ( Payload(..)
    , ResultState (..)
    , updateResult
    , initialState
    ) where

import           Control.Distributed.Process.Serializable
import           Data.Binary                              (Binary (..))
import           Data.Data
import           Data.Typeable

data Payload = Payload Double deriving (Show, Typeable, Data)

instance Binary Payload where
  put (Payload msg) = put msg
  get = Payload <$> get

-- the object sending across the network should implement Serializable
instance Serializable Payload

--
data ResultState = ResultState Integer Double deriving (Show, Eq)

initialState = ResultState 0 0.0

updateResult :: ResultState -> Payload -> ResultState
updateResult (ResultState n value) (Payload newValue) =
  let newN = n + 1
  in ResultState newN (value + (fromIntegral newN) * newValue)
