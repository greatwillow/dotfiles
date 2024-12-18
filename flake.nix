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
		inherit (self) outputs;
		artemisUser = "gdenys";
		apolloUser = "gdenys";
		artemisUserPath = "/Users/${artemisUser}";
		apolloUserPath = "/mnt/c/Users/GregoryDenys";
		artemisDotfilesPath = "${artemisUserPath}/dotfiles";
		apolloDotfilesPath = "${apolloUserPath}/dotfiles";
		system = if builtins.hasAttr "currentSystem" builtins then builtins.currentSystem else "x86_64-linux";
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
			nixos = nixpkgs.lib.nixosSystem {
				specialArgs = {inherit inputs outputs;};
				modules = ["${apolloDotfilesPath}/hosts/apollo/default.nix"];
			};
		};

		homeConfigurations = {
			"gdenys@nixos" = home-manager.lib.homeManagerConfiguration {
				pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
				extraSpecialArgs = {inherit inputs outputs;};
				modules = ["${apolloDotfilesPath}/home/linux/home.nix"];
			};
			"gdenys@PF-B58J3T3" = home-manager.lib.homeManagerConfiguration {
				pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
				extraSpecialArgs = {inherit inputs outputs;};
				modules = ["${apolloDotfilesPath}/home/linux/home.nix"];
			};
		};
	};
}
