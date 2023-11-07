# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib,  ... }:

#let
#  unstableTarball =
#    fetchTarball
#      https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
#in

#let
#  nix-software-center = import (pkgs.fetchFromGitHub {
#    owner = "vlinkz";
#    repo = "nix-software-center";
#    rev = "0.1.2";
#    sha256 = "xiqF1mP8wFubdsAQ1BmfjzCgOD3YZf7EGWl9i69FTls=";
#  }) {};
#in

#let
#  nix-gaming = import (builtins.fetchTarball "https://github.com/fufexan/nix-gaming/archive/master.tar.gz");
#in

#let
#  nixos-conf-editor = import (pkgs.fetchFromGitHub {
#    owner = "vlinkz";
#    repo = "nixos-conf-editor";
#    rev = "0.1.1";
#    sha256 = "sha256-TeDpfaIRoDg01FIP8JZIS7RsGok/Z24Y3Kf+PuKt6K4=";
#  }) {};
#in


{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
   # ./scanner.nix
    ];
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      huff = import ./home-manager/home.nix;
    };
  };


#    nixpkgs.config = {
#    packageOverrides = pkgs: with pkgs; {
#      unstable = import unstableTarball {
#        config = config.nixpkgs.config;
#      };
#    };
#   };
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.requestEncryptionCredentials = true;
  # boot.supportedFilesystems = [ "ntfs" ];


  boot.initrd.systemd.enable = true;
  boot.plymouth.enable = true;

  services.zfs.autoScrub.enable = true;

  programs.kdeconnect.enable = true;

  networking.hostName = "huff-nixos-laptop"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.hostId = "5c38be42";

  hardware.sane.enable = true;

  


  # Set your time zone.
  time.timeZone = "Europe/London";


  # Select internationalisation properties.
   i18n.defaultLocale = "en_GB.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "uk";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the Plasma 5 Desktop Environment.
   services.xserver.displayManager.sddm.enable = true;
   services.xserver.desktopManager.plasma5.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.desktopManager.cinnamon.enable = true; 
  # services.xserver.desktopManager.mate.enable = true;
  # services.xserver.desktopManager.cde.enable = true;
  # services.xserver.desktopManager.budgie.enable = true;
  # services.xserver.desktopManager.pantheon.enable = true;
  # services.xserver.desktopManager.deepin.enable = true;
  # services.xserver.desktopManager.retroarch.enable = true;
  
   hardware.bluetooth.enable = true;
   services.blueman.enable = true;
   nix.settings.experimental-features = [ "nix-command" "flakes" ];

# nix = {
#
#  package = pkgs.nixFlakes;
#  extraOptions = ''
#    experimental-features = nix-command flakes
#  '';
#};

#  services.xserver = {
#    enable = true;
#    desktopManager = {
#      xterm.enable = false;
#      xfce.enable = true;
#    };
#    displayManager.defaultSession = "xfce";
#  };
  # NVIDIA requires nonfree
  nixpkgs.config.allowUnfree = true;
  
#  programs.hyprland = {
#    enable = true;
#    xwayland.enable = true;
#    nvidiaPatches = true;
#  };
 environment.sessionVariables = {
   # If your cursor becomes invisible
   WLR_NO_HARDWARE_CURSORS = "1";
   # Hint electron apps to use wayland
   NIXOS_OZONE_WL = "1";
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
  };#
#  environment.systemPackages = [
#    (pkgs.waybar.overrideAttrs (oldAttrs: {
#       mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
#     })
#   )
#]
# XDG portal
# xdg.portal.enable = true;
# xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];


services.avahi.enable = true;
services.avahi.nssmdns = true;



 # Configure keymap in X11
   services.xserver.layout = "gb";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;


#  # Enable sound.
#  sound.enable = true;
  hardware.pulseaudio.enable = false;

  # Enable sound with pipewire.
   sound.enable = true;
   security.rtkit.enable = true;
   services.pipewire = {
     enable = true;
     alsa.enable = true;
     alsa.support32Bit = true;
     pulse.enable = true;
     jack.enable = true;
   };



  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
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
    extraGroups = [ "wheel" "libvirtd" "docker" "tty" "dialout" "networkmanager" "lp" "scanner" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      #firefox
      #thunderbird
    ];
  };
  services.tailscale.enable = true;
  virtualisation.docker.enable = true;
  services.flatpak.enable = true;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     monero-gui
     neovim
     vim_configurable # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     firefox
     evolution
     freecad 
     mpv
     vlc
     deja-dup
     duplicity
     gimp
     inkscape
     tuxpaint
     gcompris
     krita
     alacritty
     #bitwarden
     bottles
     steam
     tmux
     wine
     lutris
     cura
     prusa-slicer
     remmina
     scribus
     syncthing
     signal-desktop
     stellarium
     ungoogled-chromium
     thunderbird
     distrobox
     winetricks
     protontricks
     emacs
     transmission-remote-gtk
     steam-rom-manager
     retroarchFull
     openscad
     audacity
     ardour 
     blender
     dia
     drawio
     librecad
     sweethome3d.application
     sweethome3d.textures-editor
     sweethome3d.furniture-editor
     qlcplus
     xbill
     atanks
     libreoffice-fresh
     darktable
     monero-gui
     electrum
     heroic
     gogdl
     htop
     nvtop-nvidia
     rpi-imager
     kdenlive
     kodi
     mc
     lmms
     obs-studio
#     obs-studio-plugins
     wgnord
     virt-manager
     gnome3.gnome-tweaks
     git
     tailscale
#    nix-software-center
     appimage-run
     neofetch
     steamcmd
     steam-tui 

     ###fish shell vvv
     fishPlugins.done
     fishPlugins.fzf-fish
     fishPlugins.forgit
     fishPlugins.hydro
     fzf
     fishPlugins.grc
     grc
     ###fish shell ^^^
     # nixos-conf-editor
     kitty
     hypr
     rofi
     waybar
     docker
     libnotify
     swww
     usbutils
     electrum
     latte-dock
     yt-dlp
     hugo
     hugin
     panotools
     scantailor-advanced
     virtiofsd
     opensc
     patchelf
     dig
     whois
     metasploit
     nmap
     nextcloud-client
     home-manager
   ];

#  containers.wasabi = {
#    ephemeral = true;
#    autoStart = true;
#    config = { config, pkgs, ... }: {
#        services.httpd.enable = true;
#        services.httpd.adminAddr = "foo@example.org";
#        networking.firewall.allowedTCPPorts = [ 80 ];
#    };
#  };




  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };


  programs.fish.enable = true;  
 
#services.nextcloud = {
 # enable = true;
 # package = pkgs.nextcloud27;
 #  hostName = "localhost";
 #  config.adminpassFile = "${pkgs.writeText "adminpass" "test123"}";
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

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment? NO! - Bite ME

}

