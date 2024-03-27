#!/usr/bin/env bash
sudo nix flake update .
git add flake.lock
git commit -m "flake updated"
sudo nixos-rebuild boot --flake . --upgrade


