# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, systemSettings, ... }:

{

	imports =
		[ # Include the results of the hardware scan.
			../hardware-configuration.nix
		];


	nix = {
		settings = {
			experimental-features = [ "nix-command" "flakes" ];
		};
	};

	security.sudo = {
		execWheelOnly = true;
		extraConfig = ''
			# 1 hour between password prompts
			Defaults timestamp_timeout=60
		'';
	};


	musnix.enable = true;
	musnix.kernel.realtime = false;
	musnix.rtirq.enable = true;
	musnix.soundcardPciId = ""; # run `lspci | grep -i audio` to find the card value, such as "00:1b.0"

	# Use the systemd-boot EFI boot loader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	networking.hostName = systemSettings.hostname; # Define your hostname.

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

	security.rtkit.enable = true;

	services = {
		pulseaudio.enable = false;
		desktopManager.plasma6.enable = true;
		displayManager = {
			defaultSession = "plasmax11";
			sddm = {
	    enable = true;
	    wayland.enable = false;
			};
		};

		# Configure keymap in X11
		xserver = {
			enable = true;
			xkb.layout = "us";
			xkb.variant = "";
		};

		# Enable CUPS to print documents.
		printing.enable = true;

		pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
			# If you want to use JACK applications, uncomment this
			jack.enable = true;

			# use the example session manager (no others are packaged yet so this is enabled by default,
			# no need to redefine it in your config for now)
			#media-session.enable = true;
		};

	};


	# Enable touchpad support (enabled default in most desktopManager).
	# services.xserver.libinput.enable = true;

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.${systemSettings.username} = {
		isNormalUser = true;
		# initialPassword = "password"; # prefer the final step in installation, running `nixos-enter --root /mnt -c ...` instead
		description = systemSettings.username;
		extraGroups = [ "networkmanager" "wheel" "audio" ];
		packages = with pkgs; [ firefox jetbrains-mono vlc chromium gimp ];
	};

	# List packages installed in system profile. To search, run:
	# $ nix search wget

	#environment.systemPackages = [ (pkgs.callPackage <agenix/pkgs/agenix.nix> {}) ];

	environment.systemPackages = with pkgs; [
	#  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
	#  wget
		microcodeAmd
		micro
		wget
		git
		ardour
		qjackctl
		neofetch
		kdePackages.ksystemlog
		kdePackages.sddm-kcm
		kdePackages.isoimagewriter
		kdePackages.partitionmanager
		hardinfo2
		haruna
		libvirt
		parted
		nvd
		wireguard-tools
		efibootmgr
		pciutils
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

	#systemd.targets.sleep.enable = false;
	#systemd.targets.suspend.enable = false;
	#systemd.targets.hibernate.enable = false;
	#systemd.targets.hybrid-sleep.enable = false;

	systemd.timers = {
	};

	systemd.services = {
	};

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
