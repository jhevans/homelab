{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # 1. Bootloader (Generic UEFI)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # 2. Networking
  networking.hostName = "mini-pc";
  networking.networkmanager.enable = true;
  
  # Static IP Configuration (matching IPAM.md)
  networking.interfaces.eth0.ipv4.addresses = [ {
    address = "192.168.1.10";
    prefixLength = 24;
  } ];
  networking.defaultGateway = "192.168.1.1";
  networking.nameservers = [ "1.1.1.1" ]; # Temporary until AdGuard is up

  # 3. Time Zone & Locale
  time.timeZone = "Europe/London"; # Adjust if needed
  i18n.defaultLocale = "en_GB.UTF-8";

  # 4. User Configuration
  users.users.john = {
    isNormalUser = true;
    description = "John Evans";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPyour-ssh-key-here" # REPLACE THIS
    ];
  };

  # 5. System Packages
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
    htop
    sops
    age
    kubectl
    fluxcd
  ];

  # 6. Services (SSH & K3s)
  services.openssh.enable = true;

  # K3s Server Node
  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = "/var/lib/rancher/k3s/server/node-token"; # Or a SOPS-encrypted file later
    extraFlags = "--write-kubeconfig-mode 644 --disable traefik --disable local-storage"; # We use our own Traefik
  };

  # 7. Firewall (K3s requirements)
  networking.firewall.allowedTCPPorts = [ 6443 2379 2380 ];
  networking.firewall.allowedUDPPorts = [ 8472 ]; # Flannel VXLAN

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment? DO NOT CHANGE THIS.
}
