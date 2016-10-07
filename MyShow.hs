{-# LANGUAGE FlexibleInstances #-}
module MyShow where

import Data.Time( UTCTime )

class Read m => MyShow m where
  myShow :: m -> String

instance MyShow ([] Char) where
  myShow = id

instance MyShow UTCTime where
  myShow = show

instance MyShow Float where
  myShow = show

(&) :: (MyShow m, MyShow n) => m -> n -> String
a & b = (myShow a) ++ " " ++ (myShow b)

