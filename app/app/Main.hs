module Main where

import           CmdArgs

main :: IO ()
main = do
  args <- getCloudArgs
  print args

  return ()
