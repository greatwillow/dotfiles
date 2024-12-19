
{
  pkgs,
  rootConfigPath,
  isMacOS,
  isLinuxOS,
  isWindowsOS,
  ...
}: let
    sessionVariables = {
		IS_MAC_OS = if isMacOS then "true" else "false";
		IS_LINUX_OS = if isLinuxOS then "true" else "false";
		IS_WINDOWS_OS = if isWindowsOS then "true" else "false";
		# Editor
		EDITOR = "nvim";
		VISUAL = "nvim";
		# XDG config home
		XDG_CONFIG_HOME = "${rootConfigPath}";
		# FZF
		# Here we are using `rg` (ripgrep) as the default command for `fzf`
		# If we comment out this line and run `fzf` in the terminal, it will use `find` as the default command
		FZF_DEFAULT_COMMAND = "rg --files --hidden --glob '!.git'";
		FZF_DEFAULT_OPTS = "--height=40% --layout=reverse --border --margin=1 --padding=1";
		# BAT
		BAT_THEME = "gruvbox-dark";
		# DIRCOLORS (MacOS)
		CLICOLOR = "1";
		# Add coloring to man pages text
		LESS_TERMCAP_mb = "\e[1;32m";
		LESS_TERMCAP_md = "\e[1;32m";
		LESS_TERMCAP_me = "\e[0m";
		LESS_TERMCAP_se = "\e[0m";
		LESS_TERMCAP_so = "\e[01;33m";
		LESS_TERMCAP_ue = "\e[0m";
		LESS_TERMCAP_us = "\e[1;4;31m";
    };
in {
    sessionVariables = sessionVariables;
}