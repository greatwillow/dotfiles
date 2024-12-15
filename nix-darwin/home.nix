# home.nix
# home-manager switch 
# See Home Manager Options at: https://nix-community.github.io/home-manager/options.xhtml

{ config, pkgs, lib, ... }: let
	userPath = config.home.homeDirectory;
	dotfilesPath = "${userPath}/dotfiles";
	rootConfigPath = "${userPath}/.config";
	customPosixScriptsPath = "${rootConfigPath}/_common/posix_custom_scripts";
  	shellAliases = (import "${dotfilesPath}/_common/shell_aliases.nix" { inherit pkgs; }).shellAliases;

	# Determine the OS type
	osType = builtins.getEnv "OSTYPE";
	isMacOS = lib.strings.hasPrefix "darwin" osType;
	isLinuxOS = lib.strings.hasPrefix "linux" osType;
	isWindowsOS = lib.strings.hasPrefix "msys" osType || lib.strings.hasPrefix "cygwin" osType;
in 
{
	home.username = "gdenys";
	home.homeDirectory = "/Users/gdenys";
	home.stateVersion = "23.05"; # Please read the comment before changing.

	# Makes sense for user specific applications that shouldn't be available system-wide
	home.packages = [
		pkgs.wezterm
		pkgs.nushell
		pkgs.zsh
		pkgs.oh-my-posh
		pkgs.nerd-fonts.meslo-lg
		pkgs.bat
		pkgs.eza
		pkgs.lazygit
	];	

	# Home Manager is pretty good at managing dotfiles. The primary way to manage
	# plain files is through 'home.file'.
	home.file = {
		".config/_common".source = "${dotfilesPath}/_common";
		".config/wezterm".source = "${dotfilesPath}/wezterm";
		# ".config/skhd".source = "${dotfilesPath}/skhd";
		# ".config/starship".source = "${dotfilesPath}/starship";
		# ".config/zellij".source = "${dotfilesPath}/zellij";
		# ".config/nvim".source = "${dotfilesPath}/nvim";
		".config/nix".source = "${dotfilesPath}/nix";
		".config/nix-darwin".source = "${dotfilesPath}/nix-darwin";
		# ".config/tmux".source = "${dotfilesPath}/tmux";
		# ".config/ghostty".source = "${dotfilesPath}/ghostty";
		# ".config/aerospace".source = "${dotfilesPath}/aerospace";
		# ".config/sketchybar".source = "${dotfilesPath}/sketchybar";
		# Prompt
		".config/oh-my-posh".source = "${dotfilesPath}/oh-my-posh";
		# Shells
		".config/bash".source = "${dotfilesPath}/bash";
		".config/nushell".source = "${dotfilesPath}/nushell";
	};

	# This is needed to ensure that the font cache is updated after the fonts are installed.
	home.activation.updateFontCache = lib.hm.dag.entryAfter ["writeBoundary"] ''
		fc-cache -fv
	'';

	home.sessionVariables = {
		IS_MAC_OS = if isMacOS then "true" else "false";
		IS_LINUX_OS = if isLinuxOS then "true" else "false";
		IS_WINDOWS_OS = if isWindowsOS then "true" else "false";
		# Editor
		EDITOR = "nvim";
		VISUAL = "nvim";
		# XDG config home
		XDG_CONFIG_HOME = "${rootConfigPath}";
		# FZF
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

	home.sessionPath = [
		"/run/current-system/sw/bin"
		"$HOME/.nix-profile/bin"
		"${customPosixScriptsPath}"
	];

	programs = {
		home-manager = {
			enable = true;
		};	
		bat = {
			enable = true;
		};
		eza = {
			enable = true;
		};
		lazygit = {
			enable = true;
		};	
		zsh = (import "${dotfilesPath}/zsh/zsh.nix" { inherit pkgs shellAliases; }).zsh;
	};
}