{ config, lib, pkgs, systemSettings, ... }:

{
	nix = {
		settings = {
			experimental-features = [ "nix-command" "flakes" ];
		};
	};


	imports =
		[ 
			../hardware-configuration.nix
			./bashrc.nix
		];

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	security.sudo = {
		execWheelOnly = true;
		extraConfig = ''
			# 1 hour between password prompts
			Defaults timestamp_timeout=60
		'';
	};

	networking.hostName = systemSettings.hostname; # Define your hostname.
	networking.networkmanager.enable = true;
	time.timeZone = "America/Denver";
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

	services.desktopManager.plasma6.enable = true;
	services.displayManager = {
		defaultSession = "plasma";
		sddm = {
			enable = true;
#			theme = "mojave";
			theme = "sddm-astronaut-theme";
			wayland.enable = true;
			settings.General.DisplayServer = "wayland";
		};
	};

	services.printing.enable = true;

	# Enable sound.
	# sound.enable = true;
	# hardware.pulseaudio.enable = true;

	# Enable touchpad support (enabled default in most desktopManager).
	# services.xserver.libinput.enable = true;

	# Enable sound with pipewire.
	#sound.enable = true;
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

	users.users.${systemSettings.username} = {
		isNormalUser = true;
		#initialPassword = "password";
		description = systemSettings.username;
		extraGroups = [ "networkmanager" "wheel" "audio" ];
		packages = with pkgs; [
			firefox
			jetbrains-mono
			vlc
			chromium
			gimp
			#zoom-us
			thunderbird
		];
	};

	#environment.systemPackages = [ (pkgs.callPackage <agenix/pkgs/agenix.nix> {}) ];

	#this was used when setting up vinceliuice's McMojave sddm theme. Not using it anymore.
	#nixpkgs.overlays = [
	#	(import ./overlays/programs.nix)
	#];

	environment.systemPackages = with pkgs; [
#		sddm-mojave
		sddm-astronaut
		kdePackages.qtmultimedia
		kdePackages.sddm-kcm
		microcodeAmd
		wget
		git
		ghostty
		fastfetch
		bat
		libvirt
		gparted
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

       
	programs.nano = {
		nanorc = ''
			set nowrap
			set tabsize 4
		'';
	};

	# Open ports in the firewall.
	networking.firewall.allowedTCPPorts = [ 80 8080 8081 systemSettings.ssh_port ];
	networking.firewall.allowedUDPPorts = [ 80 8080 8081 systemSettings.ssh_port ];
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
