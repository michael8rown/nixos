{ config, pkgs, systemSettings, ... }:

{
	# TODO please change the username & home directory to your own
	home.username = systemSettings.username;
	home.homeDirectory = "/home/"+systemSettings.username;

	# Packages that should be installed to the user profile.
	home.packages = with pkgs; [

	];

	programs.bash = {
		enable = true;
		enableCompletion = true;
		# TODO add your custom bashrc here
		bashrcExtra = ''
			export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"

			# Provide a nice prompt if the terminal supports it.
			if [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; then
				PROMPT_COLOR="1;31m"
				((UID)) && PROMPT_COLOR="1;32m"
				if [ -n "$INSIDE_EMACS" ]; then
					# Emacs term mode doesn't support xterm title escape sequence (\e]0;)
					PS1="\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
				else
					PS1="\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\\$\[\033[0m\] "
				fi
				if test "$TERM" = "xterm"; then
					PS1="\[\033]2;\h:\u:\w\007\]$PS1"
				fi
			fi
		'';

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
