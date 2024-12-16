{
	description = "My multi-platform Nix configuration";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
		home-manager = {
      		url = "github:nix-community/home-manager";
      		inputs.nixpkgs.follows = "nixpkgs";
    	};
		darwin.url = "github:lnl7/nix-darwin";
    	darwin.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = inputs@{ self, nixpkgs, home-manager, darwin, ... }:
	let
		userPath = "/Users/gdenys";
		dotfilesPath = "${userPath}/dotfiles";
		system = builtins.currentSystem;
		pkgs = import nixpkgs { inherit system; };
		lib = pkgs.lib;
		isMacOS = lib.strings.hasPrefix "aarch64-darwin" system || lib.strings.hasPrefix "x86_64-darwin" system;
		isLinuxOS = lib.strings.hasPrefix "x86_64-linux" system;
		isWindowsOS = lib.strings.hasPrefix "x86_64-windows" system;
		artemisConfiguration = (import "${dotfilesPath}/hosts/artemis/default.nix" { inherit pkgs self; });
		apolloConfiguration = (import "${dotfilesPath}/hosts/apollo/default.nix" { inherit pkgs self; });
  	in
	{
		# Build darwin flake using:
		# $ darwin-rebuild build --flake .#Gregorys-MacBook-Pro
		darwinConfigurations = {
			artemis = darwin.lib.darwinSystem {
				system = "x86_64-darwin";
				modules = [ 
					artemisConfiguration
					home-manager.darwinModules.home-manager 
					{
						home-manager.useGlobalPkgs = true;
						home-manager.useUserPackages = true;
						home-manager.users.gdenys = import "${dotfilesPath}/home/default.nix";
					}
				];
			};
		};

		nixosConfigurations = {
			my-linux-config = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				modules = [
				apolloConfiguration
				home-manager.nixosModules.home-manager
				{
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.users.gdenys = import "${dotfilesPath}/home/default.nix";
				}
				];
			};
		};

		# Expose the package set, including overlays, for convenience.
    	darwinPackages = self.darwinConfigurations.artemis.pkgs;

		defaultPackage.${system} = if isMacOS then self.darwinConfigurations.artemis
			else if isLinuxOS then nixosConfigurations.my-linux-config
			else throw "Unsupported system: ${system}";
		};
}
