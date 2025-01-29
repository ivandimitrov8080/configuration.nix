{-# LANGUAGE OverloadedStrings #-}

import Turtle

parser :: Parser Text
parser = optText "host" 't' "The host to build"

getCmd :: Text -> Text
getCmd h
  | h == "nova" = "sudo nixos-rebuild switch --profile-name nova --flake .#nova"
  | h == "vps" = "nixos-rebuild switch --flake .#vps --target-host root@10.0.0.1"
  | h == "gaming" = "sudo nixos-rebuild switch --profile-name gaming --flake .#gaming"

main = do
  host <- options "xin" parser
  shell (getCmd host) empty
