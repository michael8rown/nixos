{
	description = "Server Flake";

	inputs =
		{
			nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
			agenix.url = "github:ryantm/agenix";
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
			hostname 	 = "taos";		# the name of your machine
			profile 	 = "server";		# the profile you're installing: gnome, kde, audio, or server
			username 	 = "michael";		# your username
			fullname 	 = "Michael Brown";		# your full name, such as "John Smith"
			msmtp_email  = "michael@michael8rown.com";	# email address used for msmtp
			msmtp_server = "mail.michael8rown.com";	# the mailserver address, such as `mail.yourdomain.com`
			email 		 = "michael8rown@gmail.com";			# your personal email address, such as `johnsmith@qooqle.com`
			ssh_port 	 = 23970;		# the port you use for `sshd`
			http_root 	 = "/var/www";		# the root directory of your webserver, e.g., `/var/www` or `/srv/httpd`
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
