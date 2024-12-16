# home.nix
# home-manager switch 
# See Home Manager Options at: https://nix-community.github.io/home-manager/options.xhtml

{ config, pkgs, lib, ... }: let
	user = "gdenys";
	userPath = config.home.homeDirectory;
	dotfilesPath = "${userPath}/dotfiles";
	homeManagerModulesPath = "${dotfilesPath}/home/modules";
	rootConfigPath = "${userPath}/.config";
	customPosixScriptsPath = "${homeManagerModulesPath}/_common/posix_custom_scripts";
	osType = builtins.currentSystem;
	isMacOS = lib.strings.hasPrefix "x86_64-darwin" osType;
	isLinuxOS = lib.strings.hasPrefix "x86_64-linux" osType;
	isWindowsOS = lib.strings.hasPrefix "x86_64-windows" osType;

  	shellAliases = (import "${homeManagerModulesPath}/_common/shell_aliases.nix" { inherit pkgs; }).shellAliases;
  	sessionVariables = (import "${homeManagerModulesPath}/_common/session_variables.nix" { inherit pkgs rootConfigPath isMacOS isLinuxOS isWindowsOS; }).sessionVariables;
in 
{
	home.username = "gdenys";
	home.homeDirectory = "/Users/gdenys";
	# Define the state version, which corresponds to the version of Home Manager
  	# you are using. This should be updated whenever you update Home Manager.
	home.stateVersion = "23.05";

	# Specify the desired packages to install in the user environment.
	home.packages = with pkgs; [
		wezterm
		nushell
		zsh
		oh-my-posh
		nerd-fonts.meslo-lg
		bat
		eza
		lazygit
		carapace
		ripgrep
		fzf
		neovim
	];	

	# Home Manager is pretty good at managing dotfiles. The primary way to manage
	# plain files is through 'home.file'.
	home.file = {
		# ".config/_common".source = "${homeManagerModulesPath}/_common";
		".config/wezterm".source = "${dotfilesPath}/wezterm";
		# ".config/skhd".source = "${dotfilesPath}/skhd";
		# ".config/starship".source = "${dotfilesPath}/starship";
		# ".config/zellij".source = "${dotfilesPath}/zellij";
		# ".config/nvim".source = "${dotfilesPath}/nvim";
		".config/nix".source = "${dotfilesPath}/nix";
		# ".config/nix-darwin".source = "${dotfilesPath}/nix-darwin";
		# ".config/tmux".source = "${dotfilesPath}/tmux";
		# ".config/ghostty".source = "${dotfilesPath}/ghostty";
		# ".config/aerospace".source = "${dotfilesPath}/aerospace";
		# ".config/sketchybar".source = "${dotfilesPath}/sketchybar";
	};

	# This is needed to ensure that the font cache is updated after the fonts are installed.
	home.activation.updateFontCache = lib.hm.dag.entryAfter ["writeBoundary"] ''
		fc-cache -fv
	'';

	# Ensure the Neovim directory exists and has the correct permissions
	# home.activation.ensureNvimDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
	# 	# TODO: The following commands are not working as expected. Need to investigate.
	# 	# sudo mkdir -p ${userPath}/.local/share/nvim
	# 	# chown ${user}:${user} ${userPath}/.local/share/nvim
	# 	# chmod 755 ${userPath}/.local/share/nvim
	# '';

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
		fzf = {
			enable = true;
			enableZshIntegration = true;
			enableBashIntegration = true;
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
		bash = (import "${homeManagerModulesPath}/bash/bash.nix" { inherit pkgs shellAliases; }).bash;
		zsh = (import "${homeManagerModulesPath}/zsh/zsh.nix" { inherit pkgs shellAliases; }).zsh;
		nushell = {
			enable = true;
			envFile = {
				source = "${homeManagerModulesPath}/nushell/env.nu";
			};
			configFile = {
				source = "${homeManagerModulesPath}/nushell/config.nu";
			};
		};
		# neovim = {
		# 	enable = true;
		# 	# plugins = with pkgs.vimPlugins; [];
		# };
	};
}