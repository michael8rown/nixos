# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

let
  perlEnv = pkgs.perl.withPackages (p: with p; [
    ModuleCPANfile
    ModernPerl
    AlgorithmCheckDigits
    ArrayUtils
    BusinessISBN
    BusinessISSN
    BytesRandomSecure
    CGI
    CGISession
    CGICompile
    CGIEmulatePSGI
    CacheMemcached
    CacheMemcachedFast
    ClassAccessor
    ClassFactoryUtil
    ClassInspector
    Clone
    CryptCBC
    CryptEksblowfish
    CryptOpenSSLBignum
    CryptOpenSSLRSA
    DBDMock
    DBDmysql
    DBI
    DBIxClassSchemaLoader
    DataICal
    DateCalc
    DateManip
    DateTime
    DateTimeEventICal
    DateTimeFormatICal
    DateTimeFormatMySQL
    DateTimeTimeZone
    EmailAddress
    EmailDateFormat
    EmailMessageID
    EmailSender
    EmailStuffer
    ExceptionClass
    FileSlurp
    FontTTF
    GD
    # and the rest of your modules
  ]);
in
{
  nix = {
    settings = {
      #      experimental-features = [ "nix-command" "flakes" ];
      experimental-features = [ "nix-command" ];
      #auto-optimise-store = true;
      #^^^^^ this fails -- Loaded: bad-setting (Reason: Unit nix-optimise.timer has a bad unit file setting.)
      #      Feb 17 15:15:52 nixos systemd[1]: nix-optimise.timer: Timer unit lacks value setting. Refusing.

    };
    #gc = {
    #  automatic = true;
    #  dates = "weekly";
    #  options = "--delete-older-than 7d";
    #};
  };

  security.sudo = {
    execWheelOnly = true;
    extraConfig = ''
      # 1 hour between password prompts
      Defaults timestamp_timeout=60
    '';
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
      #<agenix/modules/age.nix>
    ];


  #age = {
	    # We're letting `agenix` know where the locations of the age files will be
	    # in the server.
  #  secrets = {
  #    secret1 = {
  #      file = "/home/VAR_USERNAME/.secrets/secret1.age";
  #    };
  #    msmtp = { 
  #      file = "/home/VAR_USERNAME/.secrets/msmtp.age";
  #      owner = "VAR_USERNAME";
  #      group = "users";
	    #	group = config.users.groups.sendmail.name;
  #      mode = "0440";
  #    };
  #  };
	    # Private key of the SSH key pair. This is the other pair of what was supplied
	    # in `secrets.nix`.
	    #
	    # This tells `agenix` where to look for the private key.
  #  identityPaths = [ "/home/VAR_USERNAME/.ssh/id_ed25519" ];
  #};

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.VAR_USERNAME = import ./home.nix;
  };

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

  networking.hostName = "VAR_HOSTNAME"; # Define your hostname.
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
  time.timeZone = "America/Chicago";

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

  #home-manager.useUserPackages = true;
  #home-manager.useGlobalPkgs = true;

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
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
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
  users.users.VAR_USERNAME = {
    isNormalUser = true;
    description = "VAR_USERNAME";
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome.gnome-music
    epiphany # web browser
    gnome.tali # poker game
    gnome.iagno # go game
    gnome.hitori # sudoku game
    gnome.atomix # puzzle game
  ];

  programs.gnome-terminal.enable = true;

  #environment.systemPackages = [ (pkgs.callPackage <agenix/pkgs/agenix.nix> {}) ];

  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    microcodeAmd
    micro
    wget
    git
    neofetch
    php
    mariadb
    apacheHttpd
    msmtp
    whitesur-icon-theme
    gnome.cheese # webcam tool
    gnome.gnome-terminal
    gnome-photos
    gnome.eog
    gnome.gedit # text editor
    gnome.geary # email reader
    evince # document viewer
    libvirt
    gparted
    gnome.gnome-characters
    gnome.totem # video player
    gnome.gnome-tweaks
    gnome.gnome-themes-extra # for Adwaita-dark theme
    gnome-browser-connector
    gnome.gnome-settings-daemon43
    gnomeExtensions.dash-to-dock
    gnomeExtensions.move-clock
    gnomeExtensions.logo-menu
    gnomeExtensions.blur-my-shell
    parted
    nvd
    perlEnv
    jq
    samba
#    (callPackage <agenix/pkgs/agenix.nix> {})
    wireguard-tools
    efibootmgr
];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


  programs.msmtp = {
    enable = true;
    accounts = {
      default = {
        auth = true;
	tls = true;
        tls_starttls = false;
        from = "VAR_MSMTP_EMAIL";
        host = "VAR_MSMTP_SERVER";
        port = 465;
        user = "VAR_MSMTP_EMAIL";
        passwordeval = "${pkgs.coreutils-full}/bin/cat /home/VAR_USERNAME/.secrets/smtp.txt";
      };
    };
  };


  # List services that you want to enable:

  services = {

    # SSHD
    openssh = {
      enable = true;
      ports = [ VAR_SSH_PORT ];
    };

    # Apache
    httpd = {
      enable = true;
      adminAddr = "admin@localhost";
      enablePHP = true;

      phpOptions = ''
	; max filesize
	upload_max_filesize = 20M
	post_max_size = 20M
      '';

      virtualHosts.localhost = {
        documentRoot = "VAR_HTTP_ROOT";
        extraConfig = ''
          DirectoryIndex index.php index.html
	  <Directory "VAR_HTTP_ROOT/cgi-bin">
	      AddHandler cgi-script .cgi .pl .py
	      AllowOverride None
	      DirectoryIndex index.cgi index.pl index.py
	      Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
	      Require all granted
	  </Directory>
        '';
      };
    };


    # MariaDB
    mysql = {
      enable = true;
      package = pkgs.mariadb;
      # extraOptions = ''
      #   query_cache_type = 1
      #   query_cache_limit = 2M
      #   query_cache_size = 4M
      #   thread_cache_size = 4
      #   innodb_buffer_pool_size = 325M
      #   innodb_buffer_pool_instances = 1
      #   # smallest value since it's not used
      #   aria_pagecache_buffer_size = 128K
      #   # values should be equal
      #   tmp_table_size = 30M
      #   max_heap_table_size = 30M
      # '';
    };

    samba = {
      enable = true;
      securityType = "user";
      openFirewall = true;
      extraConfig = ''
        workgroup = WORKGROUP
        server string = smbnix
        netbios name = smbnix
        server role = standalone server
        security = user 
        follow symlinks = yes
        wide links = yes
        unix extensions = no
        max log size = 50
        #use sendfile = yes
        #max protocol = smb2
        # note: localhost is the ipv6 localhost ::1
        hosts allow = 192.168.1. 10.0. 127. localhost
        hosts deny = 0.0.0.0/0
        dns proxy = no 
        guest account = nobody
        map to guest = bad user
      '';
      shares = {
        #public = {
        #  path = "/mnt/Shares/Public";
        #  browseable = "yes";
        #  "read only" = "no";
        #  "guest ok" = "yes";
        #  "create mask" = "0644";
        #  "directory mask" = "0755";
        #  "force user" = "username";
        #  "force group" = "groupname";
        #};
        homes = {
          comment = "Home Directories";
          browseable = "no";
          writable = "yes";
        };
        nixshare = {
          path = "/home/VAR_USERNAME";
          comment = "NixOS Samba share";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "VAR_USERNAME";
          "force group" = "users";
        };
      };
    };

  }; # end of services


  #systemd.targets.sleep.enable = false;
  #systemd.targets.suspend.enable = false;
  #systemd.targets.hibernate.enable = false;
  #systemd.targets.hybrid-sleep.enable = false;


  systemd.timers = {

    "nixosUpdate" = {
      enable = false;
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "Tue 19:43:00";
	Persistent = true;
        Unit = "nixosUpdate.service";
      };
    };

    #"nixosUpdate" = {
    #  enable = true;
    #  wantedBy = [ "timers.target" ];
    #  timerConfig = {
    #    OnCalendar = "Sat 05:30:00";
    #    Persistent = true;
    #    Unit = "nixosUpdate.service";
    #  };
    #};

    "nixosStatus" = {
      enable = false;
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = [
          "Mon..Fri 16,18,22:15:00"
          "Sat,Sun 05,16,22:15:00"
        ];
        Unit = "nixosStatus.service";
      };
    };

    #"goToSleep" = {
    #  enable = false;
    #  wantedBy = [ "timers.target" ];
    #  timerConfig = {
    #    OnCalendar = "*-*-* 22:30:00";
    #    Unit = "goToSleep.service";
    #  };
    #};

  };


  systemd.services = {

    "nixosUpdate" = {
      description = "Check for NixOS updates";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "/root/update.sh";
      };
    };

    #"nixosUpdate" = {
    #  description = "Check for NixOS updates";
    #  serviceConfig = {
    #    Type = "oneshot";
    #    User = "VAR_USERNAME";
    #    ExecStart = "/home/VAR_USERNAME/checkupdates.sh";
    #  };
    #};

    "nixosStatus" = {
      description = "Status update for NixOS";
      serviceConfig = {
        Type = "oneshot";
        User = "VAR_USERNAME";
        ExecStart = "/home/VAR_USERNAME/motd-2.0.sh";
      };
    };

    #"goToSleep" = {
    #  description = "Put the system to sleep";
    #  serviceConfig = {
    #    Type = "oneshot";
    #    ExecStart = "/usr/local/bin/goToSleep";
    #    StandardOutput = "append:/home/VAR_USERNAME/.suspend.log";
    #    StandardError = "append:/home/VAR_USERNAME/.error-suspend.log";
    #  };
    #};

  };

  #services.samba-wsdd = {
  #  enable = true;
  #  openFirewall = true;
  #};

  #networking.firewall.enable = true;
  #networking.firewall.allowPing = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 80 8080 8081 VAR_SSH_PORT ];
  networking.firewall.allowedUDPPorts = [ 80 8080 8081 VAR_SSH_PORT ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
