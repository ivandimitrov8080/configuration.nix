{-# LANGUAGE OverloadedStrings #-}

import Turtle

main = do
  -- do stuff
  -- parseNixExpr 0
  shell "sudo nixos-rebuild switch --flake .#nova" empty
