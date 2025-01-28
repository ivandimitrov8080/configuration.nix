{-# LANGUAGE OverloadedStrings #-}

import Turtle

parser :: Parser Text
parser = optText "host" 't' "The host to build"

main = do
  host <- options "xin" parser
  if host == "nova"
    then do
      shell "sudo nixos-rebuild switch --flake .#nova" empty
    else
      if host == "vps"
        then do
          shell "nixos-rebuild switch --flake .#vps --target-host root@10.0.0.1" empty
        else die "no config found"
