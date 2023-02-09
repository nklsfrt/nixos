# My NixOS Flake - An IaaC adventure!

## Overview

This repo contains a [nix][nix] [flake][flake] declaring multiple [NixOS][nixos] systems that make up a significant part of my personal infrastructure.

It defines the configurations of:
- My workstations (desktop + laptop)
- A VPS for my public facing services
- A VM running self-hosted services in my home lab

## Specifics

There are certain paradigms that I am trying to make use of with this setup:

### Immutablity

Immutability is an inherent quality of the nix package manager and thus also transfers to NixOS systems. Nix makes all packages immutable by giving them their own directory identified by a hash that is derived from that package's dependencies.

### Epehemerality

My workstations are configured with ephemeral root filesystems and explicitly defined persistent storage to avoid any undeclared state that could cause configuration drift or similar. This is currently implemented via the [Impermanence][imp] module and using a `tmpfs` for `/`.

### Seperation of Concerns

My user environment is declared independently from configuration that is solely dependent on the individual system's hardware making it easily applicable to any of my systems. This is made possible by [Home Manager][hm].

In the future I intend to further seperate concerns and modularizing each systems configuration into distinct abilities to avoid as much duplicate code as possible.

## Disclaimer

This repo was not created with the intent of being used by anyone other than me. Feel free to take inspiration from it or [contact me][website] if you have questions, but I won't feel obligated to provide extensive support if you want to adopt my config.

[nixos]: https://nixos.org/
[nix]: https://nixos.wiki/wiki/Nix_package_manager
[flake]: https://nixos.wiki/wiki/Flakes
[imp]: https://github.com/nix-community/impermanence
[hm]: https://github.com/nix-community/home-manager
[website]: https://nklsfrt.de/
