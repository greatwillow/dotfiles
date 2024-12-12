{
	description = "My nix-darwin system flake";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
		nix-darwin.url = "github:LnL7/nix-darwin";
		nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
		home-manager = {
      		url = "github:nix-community/home-manager";
      		inputs.nixpkgs.follows = "nixpkgs";
    	};
	};

	outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
	let
		configuration = { pkgs, ... }: {
		# List packages installed in system profile. To search by name, run:
		# $ nix-env -qaP | grep wget
		environment.systemPackages =
			[ 
				pkgs.vim
			];

		services.nix-daemon.enable = true;
		nix.settings.experimental-features = "nix-command flakes";
		# default shell on catalina
		programs.zsh.enable = true;  
		# Set Git commit hash for darwin-version.
		system.configurationRevision = self.rev or self.dirtyRev or null; 
		system.stateVersion = 5;
		# The platform the configuration will be used on.
		nixpkgs.hostPlatform = "aarch64-darwin";
		security.pam.enableSudoTouchIdAuth = true;

		# Enable alternative shell support in nix-darwin.
		# programs.fish.enable = true;
		
		# Used for backwards compatibility, please read the changelog before changing.
		# $ darwin-rebuild changelog

		users.users.gdenys.home = "/Users/gdenys";
		home-manager.backupFileExtension = "backup";
		nix.configureBuildUsers = true;
		nix.useDaemon = true;

		system.defaults = {
			dock.autohide = true;
			dock.mru-spaces = false;
			finder.AppleShowAllExtensions = false;
			finder.AppleShowAllFiles = true;
			finder.FXPreferredViewStyle = "clmv";
			loginwindow.LoginwindowText = "Welcome!";
			screencapture.location = "~/Desktop/Screenshots2";
			screensaver.askForPasswordDelay = 10;
		};
    };
  	in
	{
		# Build darwin flake using:
		# $ darwin-rebuild build --flake .#Gregorys-MacBook-Pro
		darwinConfigurations."Gregorys-MacBook-Pro" = nix-darwin.lib.darwinSystem {
			system = "aarch64-darwin";	
			modules = [ 
				configuration
				home-manager.darwinModules.home-manager 
				{
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.users.gdenys = import ./home.nix;
				}
			];
		};

		# Expose the package set, including overlays, for convenience.
    	darwinPackages = self.darwinConfigurations."Gregorys-MacBook-Pro".pkgs;
	};
}
