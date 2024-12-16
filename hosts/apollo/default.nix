{ pkgs, self, ... }: 

{
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
	
	# Used for backwards compatibility, please read the changelog before changing.
	# $ darwin-rebuild changelog

	users.users.gdenys.home = "/Users/GregoryDenys";
	home-manager.backupFileExtension = "backup";
	nix.configureBuildUsers = true;
	nix.useDaemon = true;

	system.defaults = {};
}