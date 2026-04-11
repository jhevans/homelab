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
  networking.hostName = "control-plane-01";
  networking.networkmanager.enable = true;
  
  # Static IP Configuration (matching IPAM.md)
  networking.interfaces.eno1.ipv4.addresses = [ {
    address = "192.168.68.10";
    prefixLength = 22;
  } ];
  networking.defaultGateway = "192.168.68.1";
  networking.nameservers = [ "1.1.1.1" ]; # Temporary until AdGuard is up

  # 3. Time Zone & Locale (Matches your Installer)
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Console & X11 Keymaps (UK)
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };
  console.keyMap = "uk";

  # 4. User Configuration
  users.users.john = {
    isNormalUser = true;
    description = "John Evans";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIafTCgAfrYS9sv886yK7X3nlF2R6cdHMCD0x+EoH53V john@homelab"
    ];
  };

  # 5. System Packages
  nixpkgs.config.allowUnfree = true;
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
    # Commenting out tokenFile for initial bootstrap - K3s will generate its own.
    # tokenFile = "/var/lib/rancher/k3s/server/node-token"; 
    extraFlags = "--write-kubeconfig-mode 644 --disable traefik --disable local-storage";
  };

  # 7. Firewall (K3s requirements)
  networking.firewall.allowedTCPPorts = [ 6443 2379 2380 80 443 ];
  networking.firewall.allowedUDPPorts = [ 8472 ]; # Flannel VXLAN

  # This value determines the NixOS release from which the default
  # settings for stateful data were taken. 
  # Matches your 2026 Installer.
  system.stateVersion = "25.11"; 
}
