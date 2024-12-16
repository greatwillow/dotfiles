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
		artemisUser = "gdenys";
		apolloUser = "GregoryDenys";
		artemisUserPath = "/Users/${artemisUser}";
		apolloUserPath = "/c/Users/${apolloUser}";
		artemisDotfilesPath = "${artemisUserPath}/dotfiles";
		apolloDotfilesPath = "${apolloUserPath}/dotfiles";
		system = builtins.currentSystem;
		pkgs = import nixpkgs { inherit system; };
		lib = {
			inherit (pkgs.lib) strings;
			inherit (home-manager.lib) hm;
		};
		isMacOS = lib.strings.hasPrefix "aarch64-darwin" system || lib.strings.hasPrefix "x86_64-darwin" system;
		isLinuxOS = lib.strings.hasPrefix "x86_64-linux" system;
		isWindowsOS = lib.strings.hasPrefix "x86_64-windows" system;
		artemisConfiguration = (import "${artemisDotfilesPath}/hosts/artemis/default.nix" { inherit pkgs self; homePath = artemisUserPath; });
		apolloConfiguration = (import "${apolloDotfilesPath}/hosts/apollo/default.nix" { inherit pkgs self; homePath = apolloUserPath; });
  	in
	{
		darwinConfigurations = {
			artemis = darwin.lib.darwinSystem {
				system = "x86_64-darwin";
				modules = [ 
					artemisConfiguration
					home-manager.darwinModules.home-manager 
					{
						home-manager.useGlobalPkgs = true;
						home-manager.useUserPackages = true;
						home-manager.users.gdenys = (
							import "${artemisDotfilesPath}/home/default.nix" { 
								config = artemisConfiguration; 
								inherit pkgs lib; 
								homeUsername = artemisUser; 
								homePath = artemisUserPath; 
							}
						);
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
					home-manager.users.gdenys = (
						import "${apolloDotfilesPath}/home/default.nix" { 
							config = apolloConfiguration; 
							inherit pkgs lib; 
							homeUsername = apolloUser; 
							homePath = apolloUserPath; 
						}
					);
				}
				];
			};
		};

		defaultPackage.${system} = if isMacOS then self.darwinConfigurations.artemis
			else if isLinuxOS then self.nixosConfigurations.my-linux-config
			else throw "Unsupported system: ${system}";
		};
}
