{
	description = "Server Flake";

	inputs =
		{
			nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
		};

	outputs = inputs @ { self, nixpkgs, ... }:
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
			fullname 	 = "VAR_YOUR_NAME";		# your full name, such as "John Smith"
			msmtp_email  = "VAR_MSMTP_EMAIL";	# email address used for msmtp
			msmtp_server = "VAR_MSMTP_SERVER";	# the mailserver address, such as `mail.yourdomain.com`
			email 		 = "VAR_EMAIL";			# your personal email address, such as `johnsmith@qooqle.com`
			ssh_port 	 = VAR_SSH_PORT;		# the port you use for `sshd`
			http_root 	 = "VAR_HTTP_ROOT";		# the root directory of your webserver, e.g., `/var/www` or `/srv/httpd`
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
				]; 
			};
		};
	};
}
