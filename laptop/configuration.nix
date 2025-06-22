# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, systemSettings, ... }:

{
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
#      auto-optimise-store = true;
#      ^^^^^ this fails -- Loaded: bad-setting (Reason: Unit nix-optimise.timer has a bad unit file setting.)
#            Feb 17 15:15:52 nixos systemd[1]: nix-optimise.timer: Timer unit lacks value setting. Refusing.

    };
#    gc = {
#      automatic = true;
#      dates = "weekly";
#      options = "--delete-older-than 7d";
#    };
  };


  imports =
    [ # Include the results of the hardware scan.
      ../hardware-configuration.nix
      #<home-manager/nixos>
      #./iphone.nix
    ];

#  iphone stuff doesn't work
#  iphone.enable = true;
#  iphone.user = systemSettings.username;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  ### automatic upgrade
  #  system.autoUpgrade = {
  #    enable = true;
  #    allowReboot = false;
  #    # channel = "https://nixos.org/channels/nixos-23.11";
  #  };

  #  system.autoUpgrade.enable = true;
  #  system.autoUpgrade.allowReboot = false;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  security.sudo = {
    execWheelOnly = true;
    extraConfig = ''
      # 1 hour between password prompts
      Defaults timestamp_timeout=60
    '';
  };

  networking.hostName = systemSettings.hostname; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.interfaces.enp4s0.ipv4.addresses = [ { address = "10.11.12.122"; prefixLength = 24; } ];
  # networking.defaultGateway = "10.11.12.1";
  # networking.nameservers = [ "10.11.12.1" ];
  # networking.nameservers = [ "208,67.222.222" "8.8.8.8" ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = false;
  services.xserver.desktopManager.gnome.enable = true;
  
  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
#  services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable sound with pipewire.
  #sound.enable = true;
  hardware.pulseaudio.enable = false;
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${systemSettings.username} = {
    isNormalUser = true;
    initialPassword = "password";
    description = systemSettings.username;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      jetbrains-mono
      vlc
      rhythmbox
      chromium
      gimp
    #  zoom-us
    #  thunderbird
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     firefox
  #     tree
  #   ];
  # };

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-music
    epiphany # web browser
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ];

  programs.gnome-terminal.enable = true;

#  environment.systemPackages = [ (pkgs.callPackage <agenix/pkgs/agenix.nix> {}) ];

  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    microcodeAmd
    wget
    git
    neofetch
    libvirt
    whitesur-icon-theme
    cheese # webcam tool
    gnome-terminal
    gnome-photos
    eog
    gedit # text editor
    geary # email reader
    evince # document viewer
    gparted
    gnome-characters
    totem # video player
    gnome-tweaks
    gnome-boxes
    gnome-themes-extra # for Adwaita-dark theme
    gnome-browser-connector
    gnome-settings-daemon46
    gnomeExtensions.dash-to-dock
    gnomeExtensions.move-clock
    gnomeExtensions.logo-menu
    gnomeExtensions.blur-my-shell
    parted
    nvd
    zip
    unzip
    p7zip
    gnupg
    lsof # list open files
    ethtool
    pciutils # lspci
    ffmpeg
    tesseract
    yt-dlp
    killall
    wireguard-tools
    clamav
    efibootmgr
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

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

  # List services that you want to enable:

  services = {

    # SSHD
    openssh = {
      enable = true;
      ports = [ systemSettings.ssh_port ];
    };

  };


  systemd.timers = {

  };


  systemd.services = {

  };


  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 80 8080 8081 systemSettings.ssh_port ];
  networking.firewall.allowedUDPPorts = [ 80 8080 8081 systemSettings.ssh_port ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}
