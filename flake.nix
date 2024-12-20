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

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      darwin,
      ...
    }:
    let
      inherit (self) outputs;
      artemisUser = "gdenys";
      apolloUser = "gdenys";
      artemisUserPath = "/Users/${artemisUser}";
      apolloUserPath = "/home/${apolloUser}";
      artemisDotfilesPath = "${artemisUserPath}/dotfiles";
      apolloDotfilesPath = "${apolloUserPath}/dotfiles";
      system =
        if builtins.hasAttr "currentSystem" builtins then builtins.currentSystem else "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      lib = {
        inherit (pkgs.lib) strings;
        inherit (home-manager.lib) hm;
        inherit (home-manager.lib) file;
      };
      artemisHostPath = "${artemisDotfilesPath}/hosts/artemis";
      artemisConfigurationFile = (
        import "${artemisHostPath}/configuration.nix" {
          inherit pkgs self;
          homePath = artemisUserPath;
        }
      );
      artemisHomeFile = (
        import "${artemisHostPath}/home.nix" {
          config = artemisConfigurationFile;
          inherit pkgs lib;
          homeUsername = artemisUser;
          homePath = artemisUserPath;
        }
      );
      apolloHostPath = "${apolloDotfilesPath}/hosts/apollo";
      apolloConfigurationFile = (
        import "${apolloHostPath}/configuration.nix" {
          inherit pkgs self;
          homePath = apolloUserPath;
        }
      );
      apolloHomeFile = "${apolloHostPath}/home.nix";
      experimentalFeaturesModule = {
        nix.settings.experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
      nixPackageModule = {
        nix.package = pkgs.nix;
      };
    in
    {
      darwinConfigurations = {
        # Corresponds to the Personal MacOS
        artemis = darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          modules = [
            artemisConfigurationFile
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.gdenys = artemisHomeFile;
            }
          ];
        };
      };

      # Corresponds to the NixOS Work System - Not yet operational
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ apolloConfigurationFile ];
        };
      };

      homeConfigurations = {
        # Corresponds to the NixOS Work System - Not yet operational
        "gdenys@nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            apolloHomeFile
            experimentalFeaturesModule
            nixPackageModule
          ];
        };
        # Corresponds to the Ubuntu Work System
        "gdenys@PF-B58J3T3" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            apolloHomeFile
            experimentalFeaturesModule
            nixPackageModule
          ];
        };
      };
    };
}
