#!/usr/bin/env nu

def "main switch" [profile: string] {
    sudo nixos-rebuild switch --profile-name $profile --flake $"./#($profile)"
}

def "main target" [profile: string, target: string] {
    nixos-rebuild switch --flake $"./#($profile)" --target-host $target --use-remote-sudo
}

def main [] {
    $"Usage: todo..."
}
