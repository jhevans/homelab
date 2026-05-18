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
  networking.hostName = "gaming-pc";
  networking.networkmanager.enable = true;
  
  # 3. Time Zone & Locale
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

  # 4. Graphics & GUI (KDE Plasma 6)
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  
  # Configure X11 Keymap (UK)
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };
  console.keyMap = "uk";

  # 5. NVIDIA GPU Drivers
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false; # Use proprietary drivers for best gaming performance
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # 6. User Configuration
  users.users.john = {
    isNormalUser = true;
    description = "John Evans";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "render" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIafTCgAfrYS9sv886yK7X3nlF2R6cdHMCD0x+EoH53V john@homelab"
    ];
  };

  # 7. System Packages & Programs
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim git curl wget htop
    kubectl fluxcd
    bottles # For Ableton Live / Windows software
    wineWowPackages.stable # Wine for compatibility
    pipewire # For low-latency audio
    pavucontrol # Audio control
  ];

  programs.steam.enable = true;
  programs.steam.remotePlay.openFirewall = true;

  # 8. Services (SSH & K3s Agent)
  services.openssh.enable = true;

  # K3s Agent Node (Joins the cluster to provide GPU)
  services.k3s = {
    enable = true;
    role = "agent";
    serverAddr = "https://192.168.68.10:6443";
    # The token needs to be retrieved from the server at /var/lib/rancher/k3s/server/node-token
    tokenFile = "/var/lib/rancher/k3s/agent/token"; 
  };

  # Enable Containerd NVIDIA support
  virtualisation.containerd = {
    enable = true;
    settings = {
      plugins."io.containerd.grpc.v1.cri".containerd.runtimes.nvidia = {
        privileged_without_host_devices = false;
        runtime_type = "io.containerd.runtimes.runtime.v1.linux";
        runtime_root = "";
        runtime_engine = "";
        options = {
          BinaryName = "${pkgs.nvidia-container-toolkit}/bin/nvidia-container-runtime";
        };
      };
    };
  };

  # 9. Firewall
  networking.firewall.allowedTCPPorts = [ 6443 ];
  networking.firewall.allowedUDPPorts = [ 8472 ];

  system.stateVersion = "25.11"; 
}
