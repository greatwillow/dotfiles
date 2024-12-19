# home.nix
# home-manager switch 
# See Home Manager Options at: https://nix-community.github.io/home-manager/options.xhtml

{ config, pkgs, lib, ... }: let
  homeUsername = "gdenys";
  homePath = "/home/${homeUsername}";
	dotfilesPath = "${homePath}/dotfiles";
	homeManagerModulesPath = "${dotfilesPath}/homeManagerModules";
	rootConfigPath = "${homePath}/.config";
	customPosixScriptsPath = "${homeManagerModulesPath}/_common/posix_custom_scripts";
	osType = builtins.currentSystem;
	isMacOS = lib.strings.hasPrefix "x86_64-darwin" osType;
	isLinuxOS = lib.strings.hasPrefix "x86_64-linux" osType;
	isWindowsOS = lib.strings.hasPrefix "x86_64-windows" osType;

  	shellAliases = (import "${homeManagerModulesPath}/_common/shell_aliases.nix" { inherit pkgs homeManagerModulesPath; }).shellAliases;
  	sessionVariables = (import "${homeManagerModulesPath}/_common/session_variables.nix" { inherit pkgs rootConfigPath isMacOS isLinuxOS isWindowsOS; }).sessionVariables;
in 
{
	home.username = homeUsername;
	home.homeDirectory = homePath;
	# Define the state version, which corresponds to the version of Home Manager
  	# you are using. This should be updated whenever you update Home Manager.
	home.stateVersion = "23.05";

	# Specify the desired packages to install in the user environment.
	home.packages = with pkgs; [
		awscli2
		direnv
		dos2unix
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
    dos2unix
	];	

	# Home Manager is pretty good at managing dotfiles. The primary way to manage
	# plain files is through 'home.file'.
	home.file = {
		# ".config/_common".source = "${homeManagerModulesPath}/_common";
		# ".config/wezterm".source = "${homeManagerModulesPath}/wezterm";
		# ".config/skhd".source = "${homeManagerModulesPath}/skhd";
		# ".config/starship".source = "${homeManagerModulesPath}/starship";
		# ".config/zellij".source = "${homeManagerModulesPath}/zellij";
		# ".config/nvim".source = "${homeManagerModulesPath}/nvim";
		# ".config/nix".source = "${dotfilesPath}/nix";
		# ".config/nix-darwin".source = "${homeManagerModulesPath}/nix-darwin";
		# ".config/tmux".source = "${homeManagerModulesPath}/tmux";
		# ".config/ghostty".source = "${homeManagerModulesPath}/ghostty";
		# ".config/aerospace".source = "${homeManagerModulesPath}/aerospace";
		# ".config/sketchybar".source = "${homeManagerModulesPath}/sketchybar";
	};

	# This is needed to ensure that the font cache is updated after the fonts are installed.
	home.activation.updateFontCache = lib.hm.dag.entryAfter ["writeBoundary"] ''
		fc-cache -fv
	'';

  home.activation.debug = lib.hm.dag.entryAfter ["writeBoundary"] ''
      echo "Home Manager activation script is running"
  '';

	# Ensure the Neovim directory exists and has the correct permissions
	# home.activation.ensureNvimDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
	# 	# TODO: The following commands are not working as expected. Need to investigate.
	# 	# sudo mkdir -p ${homeUsername}/.local/share/nvim
	# 	# chown ${user}:${user} ${homeUsername}/.local/share/nvim
	# 	# chmod 755 ${homeUsername}/.local/share/nvim
	# '';

	home.sessionVariables = sessionVariables;

	home.sessionPath = [
		"/run/current-system/sw/bin"
		"$HOME/.nix-profile/bin"
		"$HOME//.nix-profile/bin"
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
		bash = (import "${homeManagerModulesPath}/bash/bash.nix" { inherit pkgs shellAliases homeManagerModulesPath; }).bash;
		zsh = (import "${homeManagerModulesPath}/zsh/zsh.nix" { inherit pkgs shellAliases homeManagerModulesPath; }).zsh;
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