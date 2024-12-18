# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
# Template originally taken from: https://github.com/Misterio77/nix-starter-configs/blob/main/minimal/nixos/configuration.nix

# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL
{
	inputs,
	lib,
	config,
	pkgs,
	...
}: {
  # You can import other NixOS modules here
	imports = [
		# If you want to use modules from other flakes (such as nixos-hardware):
		# inputs.hardware.nixosModules.common-cpu-amd
		# inputs.hardware.nixosModules.common-ssd

		# You can also split up your configuration and import pieces of it here:
		# ./users.nix

		# Import your generated (nixos-generate-config) hardware configuration
		./hardware-configuration.nix
		# include NixOS-WSL modules
		<nixos-wsl/modules>
	];

	wsl.enable = true;
	wsl.defaultUser = "gdenys";

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It's perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	# https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
	system.stateVersion = "24.05"; # Did you read the comment?

	environment.variables = {
		NIX_PATH = "/nix/var/nix/profiles/per-user/root/channels/nixos:nixos-config=/etc/nixos/configuration.nix";
	};

	nixpkgs = {
		# You can add overlays here
		overlays = [
			# If you want to use overlays exported from other flakes:
			# neovim-nightly-overlay.overlays.default

			# Or define it inline, for example:
			# (final: prev: {
			#   hi = final.hello.overrideAttrs (oldAttrs: {
			#     patches = [ ./change-hello-to-hi.patch ];
			#   });
			# })
		];
		# Configure your nixpkgs instance
		config = {
			# Disable if you don't want unfree packages
			allowUnfree = true;
		};
	};

	# Enable D-Bus service
	services.dbus = {
		enable = true;
	};

	nix = let
		flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
	in {
		settings = {
			experimental-features = "nix-command flakes";
			# Opinionated: disable global registry
			flake-registry = "";
			# Workaround for https://github.com/NixOS/nix/issues/9574
			nix-path = config.nix.nixPath;
		};
		# Opinionated: disable channels
		channel.enable = false;

		# Opinionated: make flake registry and nix path match flake inputs
		registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
		nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
	};

	# TODO: Set your hostname
	networking.hostName = "apollo";

	users.groups.gdenys = {};

	# TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
	users.users = {
		gdenys = {
			# TODO: You can set an initial password for your user.
			# If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
			# Be sure to change it (using passwd) after rebooting!
			# initialPassword = "initialPassword";
			isNormalUser = true;
			home = "/mnt/c/Users/GregoryDenys";
			openssh.authorizedKeys.keys = [
				# TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
			];
			# TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
			extraGroups = [
				"wheel" 
				"gdenys"
			];
		};
	};

	# Allow members of the wheel group to use sudo
	security.sudo = {
		enable = true;
		wheelNeedsPassword = false;  # Set to true if you want to require a password
	};

	#   # This setups a SSH server. Very important if you're setting up a headless system.
	#   # Feel free to remove if you don't need it.
	#   services.openssh = {
	#     enable = true;
	#     settings = {
	#       # Opinionated: forbid root login through SSH.
	#       PermitRootLogin = "no";
	#       # Opinionated: use keys only.
	#       # Remove if you want to SSH using passwords
	#       PasswordAuthentication = false;
	#     };
	#   };
}
