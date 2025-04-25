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
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = { huff = import ./home-manager/home.nix; };
  };
  
 # programs.gamemode.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
 


  
  fileSystems."/nfs/srv" = {
    device = "valerian:/srv";
    fsType = "nfs";
    options = [ "x-systemd.idle-timeout=600" "x-systemd.automount" "noauto" ];
  };


  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = lib.optionalString (config.nix.package == pkgs.nixVersions.stable)
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

  #additional droidcam items
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1'';
  security.polkit.enable = true;
  #########

  services.zfs.autoScrub.enable = true;

  services.gvfs.enable = true;
  services.devmon.enable = true;
  services.udisks2.enable = true;
  # services.kmscon.enable = true; 

  services.samba-wsdd = {
      # This enables autodiscovery on windows since SMB1 (and thus netbios) support was discontinued
    enable = true;
    openFirewall = true;
  };

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
 # hardware.sane.brscan5.enable = true;
  hardware.sane.extraBackends = [ pkgs.sane-airscan ];
  hardware.sane.openFirewall = true;  

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
  services = { #xserver = {
   # enable = true;
    displayManager.sddm.enable = true;
    displayManager.defaultSession = "plasma";
  };
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

 
  programs.kdeconnect.enable = true;
  programs.partition-manager.enable = true;
  hardware.bluetooth.enable = true;
  # services.blueman.enable = true;
  
  services.fwupd.enable = true;

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
    permittedInsecurePackages = [ 
      "electron-24.8.6" 
      "olm-3.2.16"
      "adobe-reader-9.5.5"
#      "googleearth-pro-7.3.6.10201"
    ];
    chromium.enableWideVine = true;
  };


  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    nvidia = {
      prime = {
       # offload.enable = true; # enable to use intel gpu (hybrid mode)
        sync.enable = true; # enable to use nvidia gpu (discrete mode)
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
      open = true; 
      modesetting.enable = true;
    };

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for FF/Chromium)
        vaapiVdpau
        libvdpau-va-gl
        nvidia-vaapi-driver
      ];
      enable32Bit = true;
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
  services.avahi.openFirewall = true;
  
  # Configure keymap in X11
  services.xserver.xkb.layout = "gb";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Add Brother printer drivers
  services.printing.drivers = [
    pkgs.brlaser
    pkgs.brgenml1lpr
    pkgs.brgenml1cupswrapper
    pkgs.cups-dymo
  ];

  services.flatpak.enable = true;


  #  # Enable sound.
  #  sound.enable = true;
  services.pulseaudio.enable = false;

  # Enable sound with pipewire.
  # sound.enable = true;
  # sound.mediaKeys.enable = true;

  security.rtkit.enable = true;
  security.pam.services.sddm.enableKwallet = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    lowLatency = {
      # enable this module
      enable = true;
      # defaults (no need to be set unless modified)
      quantum = 64;
      rate = 48000;
    };
  };


  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Virtualisation services
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
  virtualisation.spiceUSBRedirection.enable = true;
 # virtualisation.virtualbox.host.enable = true;
 # virtualisation.virtualbox.host.enableExtensionPack = true;
 #  users.extraGroups.vboxusers.members = [ "huff" ];

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
   # packages = with pkgs;
   #   [
        #firefox
        #thunderbird

   #     (wrapOBS {
       # plugins = with obs-studio-plugins; [
       #   droidcam-obs
    #    ];
     # })
     # ];
  };
 
  programs.nixvim = {
    enable = true;
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

      mini.modules.enable = true; 
      
#      lsp = {
#        enable = true;
#        servers = {
#          #javascript/typescript
#          ts-ls.enable = true;
#
#          # lua
#          lua-ls.enable = true;
#
#          #rust
#          rust-analyzer = {
#            enable = true;
#            installCargo = true;
#            installRustc = true;
#          };
#        };
#      };
    };

    
  };

  services.tailscale = {
    enable = true;
  #  extraUpFlags = [
   #   "--exit-node=" # 100.93.77.129"
     # "--exit-node-allow-lan-access" 
     # "--accept-route"
   # ];
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
    nixfmt-classic # this may change to new version nixfmt - currently as temp nixfmt-rfc-style
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
    monero-gui
    # neovim
    firefox
    evolution
    mpv
    vlc
    # libdvdread
    # libdvdcss
    ffmpeg
    # mpvc # - could not get to work?? 
    deja-dup
    duplicity
   # gimp    # - still held at 2.10 - flatpak at 3.x
    tuxpaint
    gcompris
    krita
    inkscape-with-extensions
    alacritty
    # bitwarden
    # bottles
    # steam
   # wine-wow
    # lutris
    # cura
    # prusa-slicer
    # remmina
    #  scribus
    # syncthing
    # stellarium
    ungoogled-chromium
    thunderbird
    distrobox
   # winetricks
    # protontricks
    transmission-remote-gtk
    # steam-rom-manager
    # retroarchFull
    # openscad
    audacity
    # ardour
    # blender
    dia
    drawio
    # librecad
    # sweethome3d.application
    # sweethome3d.textures-editor
    # sweethome3d.furniture-editor
    # qlcplus
    # xbill
    # atanks
    libreoffice-fresh
    darktable
    #  heroic
    # gogdl
    # legendary-gl
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
    # kitty
    # hypr
    # rofi
    # waybar
    # docker
    # libnotify
    # swww
    electrum
    # latte-dock
    yt-dlp
    # hugo
    hugin
    panotools
    scantailor-advanced
    virtiofsd
    # opensc
    # patchelf
    # metasploit
    nextcloud-client
    pavucontrol
    # helvum
    libsForQt5.kate
    # raysession
    # mame
   # wireguard-tools
    # quickemu
    jellyfin-mpv-shim
    #inputs.nix-gaming.packages.${pkgs.system}.rocket-league
    cargo
    rustc
    lshw
    libation # Audible book downloader
    # kicad
    # kicadAddons.kikit
    # kicadAddons.kikit-library
    # python311Packages.cadquery
    # cq-editor
    sc-im # terminal based spreadsheet
    neomutt #term based email client
    protonmail-bridge
    wordgrinder
    asciiquarium
    toipe
    # visidata
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
    freecad-wayland
    adobe-reader
    kdePackages.skanpage
    kdePackages.skanlite
    epsonscan2
    exiftool
    simple-scan
    bridge-utils
    adwaita-icon-theme
    font-manager
    #teams-for-linux
    #googleearth-pro
    lm_sensors
    inxi
    pciutils
  ];



  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
   #nerdfonts
   inter
   font-awesome
   lato
   open-sans
   roboto
   ubuntu_font_family 
  ];
  fonts.fontconfig.useEmbeddedBitmaps = true;
  fonts.enableDefaultPackages = true;
  
  #nixpkgs.overlays = with pkgs; [
  #    (self: super: {
  #      mpv-unwrapped = super.mpv-unwrapped.override {
  #        ffmpeg_5 = ffmpeg_5-full;
  #      };
  #    })
  #  ];

#    programs.steam = {
#    enable = true;
#    remotePlay.openFirewall =
#      true; # Open ports in the firewall for Steam Remote Play
#    dedicatedServer.openFirewall =
#      true; # Open ports in the firewall for Source Dedicated Server
#     localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
#  };


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

  
#  nix.settings = {
 #   substituters = ["https://nix-gaming.cachix.org"];
  #  trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
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

