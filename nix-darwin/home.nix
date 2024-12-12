# home.nix
# home-manager switch 

{ config, pkgs, lib, ... }:

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
	];	

	# Home Manager is pretty good at managing dotfiles. The primary way to manage
	# plain files is through 'home.file'.
	home.file = {
		".config/_common".source = "/Users/gdenys/dotfiles/_common";
		# ".zshrc".source = /Users/gdenys/dotfiles/zshrc/.zshrc;
		".config/wezterm".source = "/Users/gdenys/dotfiles/wezterm";
		# ".config/skhd".source = /Users/gdenys/dotfiles/skhd;
		# ".config/starship".source = /Users/gdenys/dotfiles/starship;
		# ".config/zellij".source = /Users/gdenys/dotfiles/zellij;
		# ".config/nvim".source = /Users/gdenys/dotfiles/nvim;
		".config/nix".source = "/Users/gdenys/dotfiles/nix";
		".config/nix-darwin".source = "/Users/gdenys/dotfiles/nix-darwin";
		# ".config/tmux".source = /Users/gdenys/dotfiles/tmux;
		# ".config/ghostty".source = /Users/gdenys/dotfiles/ghostty;
		# ".config/aerospace".source = /Users/gdenys/dotfiles/aerospace;
		# ".config/sketchybar".source = /Users/gdenys/dotfiles/sketchybar;
		# Prompt
		".config/oh-my-posh".source = "/Users/gdenys/dotfiles/oh-my-posh";
		# Shells
		".config/bash".source = "/Users/gdenys/dotfiles/bash";
		".config/nushell".source = "/Users/gdenys/dotfiles/nushell";
		".config/zsh".source = "/Users/gdenys/dotfiles/zsh";
	};

	# This is needed to ensure that the font cache is updated after the fonts are installed.
	home.activation.updateFontCache = lib.hm.dag.entryAfter ["writeBoundary"] ''
		fc-cache -fv
	'';

	home.sessionVariables = {
	};

	home.sessionPath = [
		"/run/current-system/sw/bin"
		"$HOME/.nix-profile/bin"
	];

	programs.home-manager.enable = true;
}