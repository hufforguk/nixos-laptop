#!/usr/bin/env bash
sudo nix flake update .
git add flake.nix
git commit -m "flake updated"
sudo nixos-rebuild switch --flake . --upgrade

