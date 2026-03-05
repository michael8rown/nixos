# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, systemSettings, ... }:

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
		DBDMariaDB
		DBI
		DBIxClassSchemaLoader
		DataICal
		DataDump
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
		Encode
		ExceptionClass
		FileSlurp
		FontTTF
		GD
		ListUtilsBy
		TemplateToolkit
		# and the rest of your modules
	]);
in
{

  fileSystems."/home" =
    { device = "/mnt/storage/home";
      fsType = "none";
      options = [ "bind" ];
    };

  fileSystems."/var/www" =
    { device = "/mnt/storage/www";
      fsType = "none";
      options = [ "bind" ];
    };

  fileSystems."/var/lib/libvirt/images" =
    { device = "/mnt/storage/images";
      fsType = "none";
      options = [ "bind" ];
    };

	nix = {
		settings = {
			experimental-features = [ "nix-command" "flakes" ];
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
		[ 
			../hardware-configuration.nix
			./bashrc.nix
		];

	age.secrets.msmtp = {
		file = ../secrets/msmtp.age;
		owner = systemSettings.username;
		group = "users";
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

	# Enable networking
	# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
	# networking.interfaces.enp4s0.ipv4.addresses = [ { address = "10.11.12.122"; prefixLength = 24; } ];
	# networking.defaultGateway = "10.11.12.1";
	# networking.nameservers = [ "10.11.12.1" ];
	# networking.nameservers = [ "208,67.222.222" "8.8.8.8" ];

	# Configure network proxy if necessary
	# networking.proxy.default = "http://user:password@proxy:port/";
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

#	networking = {
#		networkmanager.enable = true;
#		hostName = systemSettings.hostname;
#	};

	networking = {
		hostName = systemSettings.hostname; # Define your hostname.
		networkmanager.enable = false;
		useDHCP = false;
		defaultGateway = "${systemSettings.gateway}";
		bridges = {
			"br0" = { interfaces = [ "enp1s0" ]; };
		};
		interfaces.br0.ipv4.addresses = [ { address = "${systemSettings.ipv4}"; prefixLength = 24; } ];
	};

	virtualisation.libvirtd.enable = true;
	virtualisation.libvirtd.allowedBridges = [ "br0" ];

	# Set your time zone.
	time.timeZone = "America/Denver";

	# Select internationalisation properties.
	i18n = {
		defaultLocale = "en_US.UTF-8";
		extraLocaleSettings = {
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
	};

	# Enable CUPS to print documents.
#	services.printing.enable = true;

	# Enable sound with pipewire.
	#sound.enable = true;
#	services.pulseaudio.enable = false;
#	security.rtkit.enable = true;
#	services.pipewire = {
#		enable = true;
#		alsa.enable = true;
#		alsa.support32Bit = true;
#		pulse.enable = true;
		# If you want to use JACK applications, uncomment this
		#jack.enable = true;

		# use the example session manager (no others are packaged yet so this is enabled by default,
		# no need to redefine it in your config for now)
		#media-session.enable = true;
#	};

	# Enable touchpad support (enabled default in most desktopManager).
	# services.xserver.libinput.enable = true;

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.${systemSettings.username} = {
		isNormalUser = true;
		# initialPassword = "password";
		description = systemSettings.username;
		extraGroups = [ "libvirtd" "wheel" ];
#		packages = with pkgs; [		];
	};

	# List packages installed in system profile. To search, run:
	# $ nix search wget

	environment.systemPackages = with pkgs; [
		firefox
		chromium
		microcode-amd
		wget
		git
		fastfetch
		php
		python3
		python312Packages.selenium
		python312Packages.requests
		python312Packages.beautifulsoup4
		uv
		pyenv
#		firewalld
		chromedriver
		undetected-chromedriver
		bat
		mariadb
		apacheHttpd
		msmtp
		libvirt
		parted
		nvd
		perlEnv
		jq
		samba
		efibootmgr
		pciutils
		bc
		sshpass
		fail2ban
];

	# Some programs need SUID wrappers, can be configured further or are
	# started in user sessions.
	# programs.mtr.enable = true;
	# programs.gnupg.agent = {
	#   enable = true;
	#   enableSSHSupport = true;
	# };

	programs.nano = {
		nanorc = ''
			set nowrap
			set tabsize 4
		'';
	};

	programs.msmtp = {
		enable = true;
		accounts = {
			default = {
				auth = true;
				tls = true;
				tls_starttls = false;
				from = systemSettings.msmtp_email;
				host = systemSettings.msmtp_server;
				port = 465;
				user = systemSettings.msmtp_email;
				passwordeval = "cat ${config.age.secrets.msmtp.path}";
#				passwordeval = "${pkgs.coreutils-full}/bin/cat /home/${systemSettings.username}/.secrets/smtp.txt";
			};
		};
	};

	# List services that you want to enable:

	services = {

		logind.settings.Login = {
			HandleLidSwitch = "ignore";
			HandleLidSwitchExternalPower = "ignore";
			HandleLidSwitchDocked = "ignore";
		};

#		firewalld = {
#			enable = true;
#		};

#		resolved.enable = true;

		# SSHD
		openssh = {
			enable = true;
			ports = [ systemSettings.ssh_port ];
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
				error_reporting = E_ALL & ~E_DEPRECATED
			'';

			virtualHosts.localhost = {
				documentRoot = systemSettings.http_root;
				extraConfig = ''
					<Directory "${systemSettings.http_root}">
						DirectoryIndex index.php index.html
						AllowOverride all
						Options -Indexes +FollowSymLinks
						Require all granted
					</Directory>
				
					<Directory "${systemSettings.http_root}/cgi-bin">
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
		};

		samba = {
			enable = true;
#			securityType = "user";
			openFirewall = true;
			settings = {
				global = {
					"workgroup" = "WORKGROUP";
					"server string" = "smbnix";
					"netbios name" = "smbnix";
					"server role" = "standalone server";
					"security" = "user";
					"follow symlinks" = "yes";
					"wide links" = "yes";
					"unix extensions" = "no";
					"max log size" = "50";
					#use sendfile = yes
					#max protocol = smb2
					# note: localhost is the ipv6 localhost ::1
					"hosts allow" = "192.168.1. 10.0. 127. localhost";
					"hosts deny" = "0.0.0.0/0";
					"dns proxy" = "no";
					"guest account" = "nobody";
					"map to guest" = "bad user";
				};
				homes = {
					comment = "Home Directories";
					browseable = "no";
					writable = "yes";
				};
				nixshare = {
					path = "/home/"+systemSettings.username;
					comment = "NixOS Samba share";
					browseable = "yes";
					"read only" = "no";
					"guest ok" = "no";
					"create mask" = "0644";
					"directory mask" = "0755";
					"force user" = systemSettings.username;
					"force group" = "users";
				};
			};
		};

	}; # end of services

	systemd.targets.sleep.enable = false;
	systemd.targets.suspend.enable = false;
	systemd.targets.hibernate.enable = false;
	systemd.targets.hybrid-sleep.enable = false;

	systemd.timers = {

		"${systemSettings.hostname}Status" = {
			enable = false;
			wantedBy = [ "timers.target" ];
			timerConfig = {
				OnCalendar = [
					"Mon..Fri 05,16,18,22:15:00"
					"Sat,Sun 05,16,22:15:00"
				];
				Unit = "${systemSettings.hostname}Status.service";
			};
		};

		"br0" = {
			enable = false;
			description = "Timer to bring up network br0 two minutes after boot and start debian12 vm";
			wantedBy = [ "multi-user.target" ];
			timerConfig = {
				OnBootSec = "1min";
				Unit = "br0.service";
			};
		};

		"changedFiles" = {
			enable = false;
			description = "Timer to look for changes in directories";
			wantedBy = [ "timers.target" ];
			timerConfig = {
				OnCalendar = "*-*-* 5:20:00";
				Unit = "changedFiles.service";
			};
		};

		"ckJobs" = {
			enable = false;
			description = "Timer for job check";
			wantedBy = [ "timers.target" ];
			timerConfig = {
				OnCalendar = "*-*-* 05,11,17:30:00";
				Unit = "ckJobs.service";
			};
		};

		"ckUpd" = {
			enable = false;
			description = "Check for available updates";
			wantedBy = [ "timers.target" ];
			timerConfig = {
				OnCalendar = "Sat 05:30:00";
				Persistent = true;
				Unit = "ckUpd.service";
			};
		};

		"goToSleep" = {
			enable = false;
			description = "Put the system to sleep";
			wantedBy = [ "timers.target" ];
			timerConfig = {
				OnCalendar = "*-*-* 22:30:00";
				Unit = "goToSleep.service";
			};
		};

		"hiTemp" = {
			enable = false;
			description = "Get previous days' high temp";
			wantedBy = [ "timers.target" ];
			timerConfig = {
				OnCalendar = "*-*-* 05:10:00";
				Unit = "hiTemp.service";
			};
		};

		"lbBkup" = {
			enable = false;
			description = "Check for libro updates";
			wantedBy = [ "timers.target" ];
			timerConfig = {
				OnCalendar = "*-*-* 22:05:00";
				Unit = "lbBkup.service";
			};
		};

		"vmCtrl" = {
			enable = false;
			description = "Timer to suspend resume debian12";
			wantedBy = [ "timers.target" ];
			timerConfig = {
				OnCalendar = [
					"*-*-* 22:15:00"
					"*-*-* 05:05:00"
				];
				Unit = "vmCtrl.service";
			};
		};

		"wc" = {
			enable = false;
			description = "Check for new word counts";
			wantedBy = [ "timers.target" ];
			timerConfig = {
				OnCalendar = "*-*-* 22:20:00";
			};
		};

	};

	systemd.services = {

		"${systemSettings.hostname}Status" = {
			description = "Status alert for ${systemSettings.hostname}";
			serviceConfig = {
				Type = "oneshot";
				User = systemSettings.username;
				Group = "users";
				ExecStart = "/home/"+systemSettings.username+"/motd-2.0.sh";
			};
		};

		"br0" = {
			description = "Bring up network br0 1 minute after boot and start debian12 vm";
			requires = [ "network.target" ];
			wantedBy = [ "multi-user.target" ];
			serviceConfig = {
				Type = "oneshot";
				ExecStart = "/usr/local/bin/br0.sh";
			};
		};

		"changedFiles" = {
			description = "Look for changes in directories";
			serviceConfig = {
				Type = "oneshot";
				User = systemSettings.username;
				Group = "users";
				ExecStart = "/home/"+systemSettings.username+"/change.sh";
			};
		};

		"ckJobs" = {
			description = "Check for new jobs";
			serviceConfig = {
				Type = "oneshot";
				User = systemSettings.username;
				Group = "users";
				ExecStart = "/home/"+systemSettings.username+"/jobs/jobs.sh";
			};
		};

		"ckUpd" = {
			description = "Check for available updates";
			serviceConfig = {
				Type = oneshot";
				ExecStart = "/usr/local/bin/update.sh";
			};
		};

		"goToSleep" = {
			description = "Put the system to sleep";
			serviceConfig = {
				Type = "oneshot";
				ExecStart = "/usr/local/bin/goToSleep";
				StandardOutput = "append:/home/"+systemSettings.username+"/.suspend.log";
				StandardError = "append:/home/"+systemSettings.username+"/.suspend.log";
			};
		};

		"hiTemp" = {
			description = "Get previous days' high temp";
			serviceConfig = {
				Type = "oneshot";
				User = systemSettings.username;
				Group = "users";
				ExecStart = "/home/"+systemSettings.username+"/temp.sh";
			};
		};

		"lbBkup" = {
			description = "Check for libro updates";
			serviceConfig = {
				Type = "oneshot";
				User = systemSettings.username;
				Group = "users";
				ExecStart = "/home/"+systemSettings.username+"/db/backup";
			};
		};

		"vmCtrl" = {
			description = "Suspend/Resume debian12";
			serviceConfig = {
				Type = "oneshot";
				ExecStart = "/usr/local/bin/vmCtrl";
			};
		};

		"wc" = {
			description = "Check for new word counts";
			serviceConfig = {
				Type = "oneshot";
				User = systemSettings.username;
				Group = "users";
				ExecStart = "/home/"+systemSettings.username+"/db/wc.sh";
			};
		};

	};

	#services.samba-wsdd = {
	#  enable = true;
	#  openFirewall = true;
	#};

	#networking.firewall.enable = true;
	#networking.firewall.allowPing = true;

	# Open ports in the firewall.
	networking.firewall.allowedTCPPorts = [ 80 8080 8081 systemSettings.ssh_port ];
	networking.firewall.allowedUDPPorts = [ 80 8080 8081 systemSettings.ssh_port ];
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
