# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  specialArgs,
  ...
}: let
  unstable = specialArgs.unstable;
  mypkgs = specialArgs.mypkgs;
  pkgs-wine = specialArgs.pkgs-wine;
  gnomeExts = with pkgs.gnomeExtensions; [
    ddterm
    paperwm
    appindicator
    upower-battery
    battery-usage-wattmeter
    battery-health-charging
  ];
in {
  /*
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub.enable = true;
    grub.device = "nodev";
    grub.efiSupport = true;
  };
  # networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  networking.useNetworkd = lib.mkDefault true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  */

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  /*
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  programs.niri.enable = true;
  programs.niri.package = unstable.niri;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };
  */

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Make WiFi printing actually work
  services.printing.browsing = true;
  services.printing.browsedConf = ''
    BrowseDNSSDSubTypes _cups,_print
    BrowseLocalProtocols all
    BrowseRemoteProtocols all
    CreateIPPPrinterQueues All

    BrowseProtocols all
  '';
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  # services.snapper = {
  #   snapshotInterval = "weekly";
  #   cleanupInterval = "weekly";
  #   configs.home = {
  #     SUBVOLUME = "/home";
  #     ALLOW_USERS = ["hyperboid"];
  #     TIMELINE_CREATE = true;
  #     TIMELINE_CLEANUP = true;
  #   };
  # };
  services.flatpak.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  /*
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hyperboid = {
    isNormalUser = true;
    description = "Hyperboid";
    extraGroups = ["networkmanager" "wheel" "docker"];
    shell = pkgs.zsh;
    packages = with pkgs;
      [
        thunderbird
        keepassxc
        wl-clipboard
        gjs
        vte
        lftp
      ]
      ++ (with unstable; [
        yt-dlp
        mpv
        ydotool
        swaylock-effects
      ])
      ++ gnomeExts;
  };
  */

  # Install firefox.
  programs.firefox.enable = true;
  # programs.zsh.enable = true;
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    vte
    libhandy
    glib
    xorg.libxshmfence
    nss
    nspr
    atkmm
   ] ++ (with unstable; [
    at-spi2-atk
    cups.lib
    dbus.lib
    libdrm
    gtk3
    pango
    cairo
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libgbm
    expat
    libxcb
    libxkbcommon
  ]);
  programs.kdeconnect = {
    enable = true;
  };
  programs.steam = {
    enable = true;
    # extest.enable = true;
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = (with pkgs; [
    bat
    distrobox
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    htop
    libqalculate
    (pkgs.writeShellScriptBin "love11" "exec -a love ${love}/bin/love $@")
  /*
    gitFull
    fzf
    zoxide
    pkgs-wine.wineWowPackages.unstable
    gnome-extension-manager
    vte
    libhandy
    gedit
    openssl
    busybox
    pulseaudio
    inotify-tools
    kitty
    ruffle
    python3
  */
  ]) ++ (with mypkgs; [
    # love
  ]);
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
      obs-backgroundremoval
      obs-vkcapture
    ];
  };
  programs.appimage = {
    enable = true;
    # Breaks appimages in distrobox containers, which is needed for GameMaker
    binfmt = false;
    package = pkgs.appimage-run.override { extraPkgs = pkgs: [
      pkgs.icu72
      pkgs.libxcrypt-legacy
    ];};
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  /*
  services.openssh.enable = true;
  services.kanata = {
    enable = true;
    keyboards = {
      laptop = {
        devices = ["/dev/input/by-path/platform-i8042-serio-0-event-kbd"];
        config = builtins.readFile ./laptop/kanata/config.kbd;
      };
    };
  };
  systemd.services.kanata-laptop.serviceConfig.User = lib.mkForce "root";

  */
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  /*

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  networking.firewall.allowedUDPPorts = [
    # Gaster's Cool Social Network!
    25574
  ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  home-manager.extraSpecialArgs = specialArgs;
  */
}
