# Many thanks to stigok for this template; modeled on his irssi override
{ nixpkgs, ... }: {
  nixpkgs.config.packageOverrides = pkgs:
    let
      inherit (pkgs.perlPackages) makePerlPath;
      deps = with pkgs.perlPackages; [
#	Turns out we don't need this (?) because it's in configuration.nix (?)
#		ModernPerl
#		CGI
#		CGISession
#		CGICompile
#		CGIEmulatePSGI
#		DBDMariaDB
#		DBI
#		DBIxClassSchemaLoader
#		DateTime
#		Encode
      ];
    in {
      apacheHttpd = pkgs.apacheHttpd.overrideAttrs (oldAttrs: {
        buildInputs = oldAttrs.buildInputs ++ [ pkgs.makeWrapper ] ++ deps;
        postFixup = ''
          wrapProgram "$out/bin/httpd" --prefix PERL5LIB : "${makePerlPath deps}"
        '';
      });
    };
}
