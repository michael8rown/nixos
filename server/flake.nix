{
	description = "Server Flake";

	inputs =
		{
			nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
			agenix.url  = "github:ryantm/agenix";
		};

	outputs = inputs @ { self, nixpkgs, agenix, ... }:
	let
		system = "x86_64-linux";
		pkgs = import nixpkgs {
			inherit system;
			config.allowUnfree = true;
		};
		lib = nixpkgs.lib;

		systemSettings = {
			hostname 	 = "VAR_HOSTNAME";		# the name of your machine
			profile 	 = "VAR_PROFILE";		# the profile you're installing: gnome, kde, audio, or server
			username 	 = "VAR_USERNAME";		# your username
			fullname 	 = "VAR_FULLNAME";		# your full name, such as "John Smith"
			msmtp_email  = "VAR_MSMTP_EMAIL";	# email address used for msmtp
			msmtp_server = "VAR_MSMTP_SERVER";	# the mailserver address, such as `mail.yourdomain.com`
			email 		 = "VAR_EMAIL";			# your personal email address, such as `johnsmith@qooqle.com`
			ssh_port 	 = VAR_SSH_PORT;		# the port you use for `sshd`
			http_root 	 = "VAR_HTTP_ROOT";		# the root directory of your webserver, e.g., `/var/www` or `/srv/httpd`
			gateway 	 = "VAR_GATEWAY";		# the default gateway, eg., 192.182.122.1 or 10.0.0.1
			ipv4 	 	 = "VAR_IPV4";			# the manually-set ip address for this machine, eg. 10.0.0.127
		};

	in
	{
		nixosConfigurations = {
			${systemSettings.hostname} = lib.nixosSystem {
				inherit system;
				specialArgs = {
					inherit systemSettings;
				};
				modules = [ 
					(./. + ("/" + systemSettings.profile) + "/configuration.nix")
					agenix.nixosModules.default
					{ environment.systemPackages = [ agenix.packages.${system}.default ]; }
				]; 
			};
		};
	};
}
