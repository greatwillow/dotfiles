# home.nix
# home-manager switch 
# See Home Manager Options at: https://nix-community.github.io/home-manager/options.xhtml

{ config, pkgs, lib, ... }: let
	userPath = config.home.homeDirectory;
	dotfilesPath = "${userPath}/dotfiles";
	rootConfigPath = "${userPath}/.config";
	customPosixScriptsPath = "${rootConfigPath}/_common/posix_custom_scripts";
	osType = builtins.currentSystem;
	isMacOS = lib.strings.hasPrefix "x86_64-darwin" osType;
	isLinuxOS = lib.strings.hasPrefix "x86_64-linux" osType;
	isWindowsOS = lib.strings.hasPrefix "x86_64-windows" osType;

  	shellAliases = (import "${dotfilesPath}/_common/shell_aliases.nix" { inherit pkgs; }).shellAliases;
  	sessionVariables = (import "${dotfilesPath}/_common/session_variables.nix" { inherit pkgs rootConfigPath isMacOS isLinuxOS isWindowsOS; }).sessionVariables;
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
		pkgs.carapace
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
	};

	# This is needed to ensure that the font cache is updated after the fonts are installed.
	home.activation.updateFontCache = lib.hm.dag.entryAfter ["writeBoundary"] ''
		fc-cache -fv
	'';

	home.sessionVariables = sessionVariables;

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
		carapace = {
			enable = true;
			enableNushellIntegration = true;
			enableZshIntegration = true;
			enableBashIntegration = true;
		};
		oh-my-posh = {
			enable = true;
			enableZshIntegration = true;
			enableBashIntegration = true;
			enableNushellIntegration = true;
		};
		bash = (import "${dotfilesPath}/bash/bash.nix" { inherit pkgs shellAliases; }).bash;
		zsh = (import "${dotfilesPath}/zsh/zsh.nix" { inherit pkgs shellAliases; }).zsh;
		nushell = {
			enable = true;
			envFile = {
				source = "${dotfilesPath}/nushell/env.nu";
			};
			configFile = {
				source = "${dotfilesPath}/nushell/config.nu";
			};
		};
	};
}