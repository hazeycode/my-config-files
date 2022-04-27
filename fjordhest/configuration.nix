# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Choose a kernel version
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Configure graphics
  hardware.enableRedistributableFirmware = true;
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
  
  networking.hostName = "fjordhest"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/London";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp7s0.useDHCP = true;
  networking.interfaces.wlp6s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Configure xserver, window manager, etc.
  services.xserver.enable = true;
  services.xserver.autorun = true;
  services.xserver.windowManager.dwm.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.chris = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
    packages = with pkgs; [
      git
      helix
      firefox
    ];  
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    xclip
    dmenu
    st
    cheat
  ];

  # Define package overlays
  nixpkgs.overlays = with pkgs; [
    (self: super: {
      dwm = super.dwm.overrideAttrs (oldAttrs: rec {
        configFile = writeText "config.def.h" (builtins.readFile "${fetchFromGitHub { owner="hazeycode"; repo="my-config-files"; rev="333acb238fe8b18fb5ceac67d0cbf48ce5e3cdda"; sha256="1g9fc0kdnv2i1rly63ayz0n0l6fjlkfilwaj2j1i8bdndnhhcpz0"; }}/dwm/config.h");
        postPatch = "${oldAttrs.postPatch}\n cp ${configFile} config.def.h";
      });
      st = super.st.overrideAttrs (oldAttrs: rec {
        patches = [
          (fetchpatch {
            url = "https://st.suckless.org/patches/nordtheme/st-nordtheme-0.8.2.diff";
            sha256 = "0ssj7gsb3snk1pqfkffwc0dshrbmvf7ffqvrdi4k2p451mnqmph1";
          })
        ];
        configFile = writeText "config.def.h" (builtins.readFile "${fetchFromGitHub { owner="hazeycode"; repo="my-config-files"; rev="333acb238fe8b18fb5ceac67d0cbf48ce5e3cdda"; sha256="1g9fc0kdnv2i1rly63ayz0n0l6fjlkfilwaj2j1i8bdndnhhcpz0"; }}/st/config.h");
        postPatch = "${oldAttrs.postPatch}\n cp ${configFile} config.def.h";
      });
    })
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.fish.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

