# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    # ./scanner.nix
    inputs.nixvim.nixosModules.nixvim
  #  inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = { huff = import ./home-manager/home.nix; };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
 

  
  fileSystems."/nfs/srv" = {
    device = "valerian:/srv";
    fsType = "nfs";
    options = [ "x-systemd.idle-timeout=600" "x-systemd.automount" "noauto" ];
  };
 

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes";
  };
 
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.requestEncryptionCredentials = true;
  # boot.supportedFilesystems = [ "ntfs" ];
  # boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.initrd.systemd.enable = true;
  boot.plymouth.enable = true;

  services.zfs.autoScrub.enable = true;

  services.gvfs.enable = true;
  services.devmon.enable = true;
  services.udisks2.enable = true;


  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged
    # programs here, NOT in environment.systemPackages

  ];

  powerManagement.enable = true;

  networking.hostName = "huff-nixos-laptop"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.
  networking.hostId = "5c38be42";

  hardware.sane.enable = true;
  hardware.sane.brscan5.enable = true;



  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "uk";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };
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


  # Enable the X11 windowing system & the Plasma 6 Desktop Environment
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    displayManager.defaultSession = "plasma";
  };
  services.desktopManager.plasma6.enable = true;

  programs.kdeconnect.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  programs.tmux = {
    enable = true;
    clock24 = true;
    terminal = "tmux-256color";
    plugins = with pkgs;
    [
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.catppuccin
      tmuxPlugins.sidebar
      tmuxPlugins.online-status
      tmuxPlugins.weather
    ];

  };

  # NVIDIA requires nonfree
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ "electron-24.8.6" ];
  };


  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    nvidia = {
      prime = {
        offload.enable = true; # enable to use intel gpu (hybrid mode)
        # sync.enable = true; # enable to use nvidia gpu (discrete mode)
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
      modesetting.enable = true;
    };

    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for FF/Chromium)
        vaapiVdpau
        libvdpau-va-gl
      ];
      driSupport = true;
      driSupport32Bit = true;
    };
  };
  #  environment.systemPackages = [
  #    (pkgs.waybar.overrideAttrs (oldAttrs: {
  #       mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
  #     })
  #   )
  #]

  # XDG portal
  # xdg.portal.enable = true;
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-kde ];

  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "gb";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;


  services.flatpak.enable = true;


  #  # Enable sound.
  #  sound.enable = true;
  hardware.pulseaudio.enable = false;

  # Enable sound with pipewire.
  sound.enable = true;
  sound.mediaKeys.enable = true;

  security.rtkit.enable = true;
  security.pam.services.sddm.enableKwallet = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    #lowLatency = {
      # enable this module
     # enable = true;
      # defaults (no need to be set unless modified)
    #  quantum = 64;
    #  rate = 48000;
    #};
  };


  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Virtualisation services
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "huff" ];

  programs.dconf.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.huff = {
      isNormalUser = true;
      initialPassword = "pw321";
      extraGroups = [
        "wheel"
        "libvirtd"
        "docker"
        "tty"
        "dialout"
        "networkmanager"
        "lp"
        "scanner"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs;
      [
        #firefox
        #thunderbird
      ];
  };
 
  programs.nixvim.enable = true;
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      vim-nix
    #  neotree
    #  fugative
    #  nvim-cmp

    ];
    enableMan = true;

    colorschemes.gruvbox.enable = true;

    plugins = {
      fugitive.enable = true;
      openscad.enable = true;
      neo-tree.enable = true;

      lsp = {
        enable = true;
        servers = {
          #javascript/typescript
          tsserver.enable = true;

          # lua
          lua-ls.enable = true;

          #rust
          rust-analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
        };
      };
    };

    
  };

  services.tailscale = {
    enable = true;
    extraUpFlags = [
      "--exit-node=" # 100.93.77.129"
     # "--exit-node-allow-lan-access" 
     # "--accept-route"
    ];
  };

#  services.ollama = {
#    enable = true;
#    acceleration = "cuda";
#  };

  virtualisation.docker.enable = true;
#  services.flatpak.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim_configurable
    home-manager
    nixfmt
    htop
    tmux
    wget
    emacs
    mc
    gitFull
    tailscale
    neofetch
    usbutils
    dig
    nmap
    whois
    # monero-gui
    # neovim
    firefox
    evolution
    freecad
    mpv
    vlc
    libdvdread
    libdvdcss
    ffmpeg
    # mpvc # - could not get to work?? 
    deja-dup
    duplicity
    gimp
    inkscape
    tuxpaint
    gcompris
    krita
    alacritty
    # bitwarden
    # bottles
    # steam
    # wine
    # lutris
    #cura
    prusa-slicer
    remmina
    scribus
    syncthing
    stellarium
    ungoogled-chromium
    thunderbird
    distrobox
    # winetricks
    # protontricks
    transmission-remote-gtk
    # steam-rom-manager
    #retroarchFull
    openscad
    audacity
    ardour
    blender
    dia
    drawio
    librecad
    # sweethome3d.application
    #sweethome3d.textures-editor
    # sweethome3d.furniture-editor
    # qlcplus
    # xbill
    # atanks
    libreoffice-fresh
    darktable
    # monero-gui
    electrum
    # heroic
    # gogdl
    nvtopPackages.nvidia
    rpi-imager
    # kdenlive
    # kodi
    # lmms
    # obs-studio
    virt-manager
    tailscale-systray
    appimage-run
    # steamcmd
    # steam-tui
    kitty
    hypr
    rofi
    #waybar
    docker
    libnotify
    swww
    electrum
    # latte-dock
    yt-dlp
    hugo
    hugin
    panotools
    scantailor-advanced
    virtiofsd
    # opensc
    # patchelf
    # metasploit
    nextcloud-client
    pavucontrol
    helvum
    libsForQt5.kate
    raysession
    # mame
    wireguard-tools
    quickemu
    jellyfin-mpv-shim
    # inputs.nix-gaming.packages.${pkgs.system}.rocket-league
    cargo
    rustc
    lshw
    kicad
    kicadAddons.kikit
    kicadAddons.kikit-library
    # python311Packages.cadquery
    # cq-editor
    sc-im
    neomutt
    protonmail-bridge
    wordgrinder
    asciiquarium
    toipe
    visidata
    dialog
    alpine
    bsdgames
    neo-cowsay
    lolcat
    figlet
    nethack
    scrcpy
    imagemagickBig
    fontforge-gtk
    meshlab
    onlyoffice-bin_latest
    wireplumber
    brlaser
  ];


  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];
  #nixpkgs.overlays = with pkgs; [
  #    (self: super: {
  #      mpv-unwrapped = super.mpv-unwrapped.override {
  #        ffmpeg_5 = ffmpeg_5-full;
  #      };
  #    })
  #  ];

 # programs.steam = {
 #   enable = true;
 #   remotePlay.openFirewall =
 #     true; # Open ports in the firewall for Steam Remote Play
 #   dedicatedServer.openFirewall =
 #     true; # Open ports in the firewall for Source Dedicated Server
 # };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  
  nix.settings = {
    substituters = ["https://nix-gaming.cachix.org"];
    trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
 #   #substituters = ["https://hyprland.cachix.org"];
 #   #trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
   


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment? NO! - Bite ME

}

