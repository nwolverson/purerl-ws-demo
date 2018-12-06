module WsDemo.Model where

type Load = {
  avg1 :: Int,
  avg5 :: Int,
  avg15 :: Int
}

type Message = {
  load :: Load
}