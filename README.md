# nixos-config
This repository contains my NixOS server configuration.

## setup

* Checkout this repository to `/etc/nixos/nixos-config`.
* Replace the contents of /etc/nixos/configuration.nix with
```
{ ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./nixos-config/{server-name}/configuration.nix
    ];
}

```

