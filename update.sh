#!/usr/bin/env bash
sudo nix flake update --flake .
git add flake.lock
git commit -m "flake updated"
sudo nixos-rebuild switch --flake . --upgrade



