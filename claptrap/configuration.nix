# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    docker-compose
    git
    htop
    mt-st
    sg3_utils
    tmux
    vim
    wget
    inetutils
  ];

  services.openssh.enable = true;
  services.openssh.kbdInteractiveAuthentication = false;
  services.openssh.passwordAuthentication = false;

  virtualisation.docker.enable = true;

  services.cron = {
    enable = true;
    systemCronJobs = [
      "20 3 * * 6 root docker image prune --all --force > /var/log/cron/docker-image-prune.log"
      "25 3 * * 6 root nix-collect-garbage -d > /var/log/cron/nix-collect-garbage.log"
      "30 3 * * * root docker exec seafile-server /scripts/gc.sh > /var/log/cron/seafile-gc.log"
    ];
  };

  systemd.timers.nixos-upgrade = {
    wantedBy = [ "timers.target" ];
    partOf = [ "nixos-upgrade.service" ];
    timerConfig.OnCalendar = [ "*-*-* 03:00:00" ];
  };

  users.mutableUsers = false;

  users.users.nikos = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keyFiles = [ ../nikos_authorized_keys ];
    # Plaintext in BitWarden
    # Only for local access -> services.openssh.passwordAuthentication is disabled!
    hashedPassword = "$6$6eJ3cM/8cGwsnwlg$ik9FZkPiTp.GEqiCwhuHBNjhMq/hxXzYPWFWgj5N7jIRXL6fc6XlT.klsfMvKLn8sTYgxoCH909.XAgzIwgnL0";
    shell = pkgs.zsh;
  };
 
  system.autoUpgrade.enable = true;
  system.autoUpgrade.channel = https://nixos.org/channels/nixos-22.11-small;
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
  networking.nameservers = [ "2620:fe::11" "2620:fe::fe:11" "9.9.9.10" "149.112.112.11" ];
  
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp6s0.useDHCP = true;
  
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 80 443 9001 9030 ];

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

