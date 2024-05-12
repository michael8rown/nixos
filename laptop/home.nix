{ config, pkgs, ... }:

{
  # TODO please change the username & home direcotry to your own
  home.username = "YOURUSERNAME";
  home.homeDirectory = "/home/YOURUSERNAME";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
#  xresources.properties = {
#    "Xcursor.size" = 16;
#    "Xft.dpi" = 172;
#  };

  gtk = {
    enable = true;

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };

    iconTheme = {
      name = "WhiteSur-dark";
      package = pkgs.whitesur-icon-theme;
    };

#    gtk3.extraConfig = {
#      settings = ''
#        gtk-application-prefer-dark-theme=1
#      '';
#    };

#    gtk4.extraConfig = {
#      settings = ''
#        gtk-application-prefer-dark-theme=1
#      '';
#    };


# This makes dash-to-dock the blue color:
# /org/gtk/gtk4/settings/color-chooser/selected-color
#  (true, 0.30980393290519714, 0.3960784375667572, 0.51764708757400513, 1.0)


    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

  };

  dconf = {
    enable = true;
    settings = {

      "org/gnome/gedit/preferences/editor" = {
	display-line-numbers = false;
	wrap-mode = "none";
	highlight-current-line = false;
	bracket-matching = false;
	use-default-font = false;
	editor-font = "Monospace 12";
      };

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
	clock-format = "12h";
      };

      "org/gnome/desktop/wm/preferences".button-layout = "appmenu:minimize,maximize,close";

      "org/gnome/mutter" = {
	edge-tiling = true;
	dynamic-workspaces = true;
	center-new-windows = true;
      };

      "org/gnome/nautilus/preferences".show-image-thumbnails = "always";

      "org/gnome/desktop/privacy".remember-recent-files = false;

      "org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9" = {
        default-size-rows = 27;
        default-size-columns = 127;
	use-system-font = false;
        font = "JetBrains Mono 10";
        scrollbar-policy = "never";
      };

      "org/gnome/shell" = {
        disable-user-extensions = false;

        # `gnome-extensions list` for a list
        enabled-extensions = [
	  "Move_Clock@rmy.pobox.com"
	  "blur-my-shell@aunetx"
	  "dash-to-dock@micxgx.gmail.com"
	  "logomenu@aryan_k"
        ];

	favorite-apps = [
	  "org.gnome.Nautilus.desktop"
	  "firefox.desktop"
	  "org.gnome.Terminal.desktop"
	  "org.gnome.gedit.desktop" 
	  "vlc.desktop"
	  "org.gnome.Rhythmbox3.desktop"
	  "gimp.desktop"
	  "org.gnome.tweaks.desktop"
	  "org.gnome.Settings.desktop"
        ];

      };

      "org/gnome/shell/extensions/Logo-menu" = {
	menu-button-icon-image = 18;
	symbolic-icon = false;
	show-power-options = true;
	show-lockscreen = true;
	hide-softwarecentre = true;
      };

      "org/gnome/shell/extensions/dash-to-dock" = {
	dash-max-icon-size = 38;
	transparency-mode = "FIXED";
	custom-background-color = true;
	background-color = "rgb(94,95,97)";
	background-opacity = 0.90;
        custom-theme-shrink = true;
      };  

    };
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [

  ];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "YOUR NAME";
    userEmail = "YOUREMAIL@DOMAIN.com";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO add your custom bashrc here
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    # set some aliases, feel free to add more or remove some
#    shellAliases = {
#      k = "kubectl";
#      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
#      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
#    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
