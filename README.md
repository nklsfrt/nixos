# My NixOS Flake

## Overview

This repo contains a [nix][nix] [flake][flake] declaring multiple [NixOS][nixos] systems that make up a significant part of my personal infrastructure.

It defines the configurations of:
- My workstations (desktop + laptop)
- A VPS for my public facing services
- My [home-server][homelab] which does all my routing, runs various self-hosted services and handles my backups.

## Why NixOS?

There are a number of reasons I chose NixOS for my personal infrastructure, to name the major ones:

### Immutability

NixOS's immutable approach to package management and configuration provides a number of benefits for system administrators _and_ developers. By ensuring that infrastructure components cannot be modified once they are deployed, it helps reducing the risk of errors, conflicts, and other issues that can arise from changes to the system's state.

### Reproducibility

Another key benefit of NixOS is its high degree of reproducibility. By fully defining the system's configuration and package installations, NixOS makes it easy to reproduce the same system state on multiple machines or at different points in time. It also provides tools for ensuring reproducibility at the package level, using a deterministic build process and a content-addressed store to ensure that packages are consistent and free from tampering.

## Specifics

There are certain paradigms that I am trying to adhere to with this setup:

### Ephemerality and opt-in state

My workstations are configured with ephemeral root file systems and explicitly defined persistent storage to avoid any undeclared state that could cause configuration drift or similar.
This is currently implemented via the [Impermanence][imp] module and using a `tmpfs` for `/`.

### Separation of Concerns

My user environments and system configurations are declared independently from configuration that is solely dependent on the individual system's hardware, making them easily interchangeable and applicable to any of my systems. This is made possible by [Home Manager][hm].

I am currently working on further separating things by modularizing each systems configuration into distinct abilities/roles/profiles to avoid as much duplicate code as possible.

### Prioritization by Specificity

For any given configuration to be made:

The _method used_ to declare it is preferred from highest to lowest specificity:

1. Is there an home option available via Home Manager?
2. Is there a system-wide option available via NixOS?
3. Does Nix provide a way to manually implement what I want?
4. Bind mount necessary configuration via persistent storage if applicable.

The _place_ it is declared in is chosen from lowest to highest specificity:

1. Common system/user configuration applied to every system.
2. Inside reusable modules applied to systems on-demand.
3. System specific, individual configuration.

This not only avoids a lot of duplicate code, but also reduces the chances of values being over-declared and having to deal with defaults and overrides explicitly.

### Secret Management

Since this flake is aiming to be an exhaustive declaration of my infrastructure, there is the need to deal with secrets in a confidential manner. I am using [sops-nix][sops-nix] - a NixOS module implementation of Mozilla's [SOPS][sops] - to be able to store secret information securely encrypted in this repo. Those secrets are then decrypted at activation time for the system to use during runtime.

## Disclaimer

This repo was not created with the intent of being used by anyone other than me. Feel free to take inspiration from it or [contact me][website] if you have questions, but I will not feel obligated to provide extensive support if you want to adopt my config.

[nixos]: https://nixos.org/
[homelab]: #
[nix]: https://nixos.wiki/wiki/Nix_package_manager
[flake]: https://nixos.wiki/wiki/Flakes
[imp]: https://github.com/nix-community/impermanence
[hm]: https://github.com/nix-community/home-manager
[sops-nix]: https://github.com/Mic92/sops-nix
[sops]: https://github.com/mozilla/sops
[website]: https://nklsfrt.de/
