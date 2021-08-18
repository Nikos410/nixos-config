# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    docker-compose
    git
    htop
    vim
    wget
  ];

  services.openssh.enable = true;

  virtualisation.docker.enable = true;

  users.mutableUsers = false;

  users.users.nikos = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keyFiles = [ ./nikos_authorized_keys ];
    shell = pkgs.zsh;
  };
 
  users.users.jan = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpK0nqpxKtD/nnNPhKkVQf2ab/0hOnec5BrHTjxiFFc/N9Sxhdl/374bUygCvBdB3i+bJO0Y9rAjtBaYwO54QLJTcQKt1y2Za7zLHPoZiFpXxdMXSqb6D96h5BvpZ+nyHdbZtDjwbAREj9+AHIp8zWwG9bN6pCg7zK0ZvEKNM/IdZCcTYXasjpj2EJ8MEaSMjfRwfG/zflHMeHZyuQXO/KbLziSrEGP5Wq2xJkKe4axMQR66KZR5x95lcAyBUO0Ow55s5uMxmAJTdizs4SVOTNaMSCYsQLISkChx1NUSPFY7XM1zf33Zq1mNlZs9ZiHT03p/YBm9U3NZqOh3L4XU3H jan-backup@raspberrypi" ];
    shell = pkgs.zsh;
    home = "/srv/no-backup/jan" ;
  };


  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  system.autoUpgrade.enable = true;
  system.autoUpgrade.channel = https://nixos.org/channels/nixos-21.05;
  system.autoUpgrade.allowReboot = true;

  security.sudo.extraRules = [
    {
      groups = [ "wheel" ];
      commands = [
        { command = "ALL"; options = [ "NOPASSWD" ]; }
      ];
    }
  ];

  time.timeZone = "Europe/Berlin";

  networking.hostName = "claptrap";
  
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp4s0.useDHCP = true;
  
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];

  fileSystems."/srv" =
  { 
    device = "/dev/disk/by-uuid/8f27effa-0b86-44b3-89dd-86a1974c8cd9";
    fsType = "ext4";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}

