{
  description = "Mike's Server Flake";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
      home-manager = {
        url = "github:nix-community/home-manager/release-23.11";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

  outputs = inputs @ { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    lib = nixpkgs.lib;
  in
  {
    nixosConfigurations = {
      VAR_HOSTNAME = lib.nixosSystem {
	inherit system;
	modules = [ 
	  ./configuration.nix
	  home-manager.nixosModules.home-manager {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.users.VAR_USERNAME = {
	      imports = [ ./home.nix ];
	    };
	  }
	]; 
      };
    };
  };
}
