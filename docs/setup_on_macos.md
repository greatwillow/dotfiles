## Setup on Personal MacOS

The configuration setup on MacOS uses Nix-Darwin.

**1. Ensure Git is Installed and Present**

**2. Install Nix and Nix-Darwin**

**3. Optional - Install Home-Manager**

This implementation uses the [nix-darwin modules](https://nix-community.github.io/home-manager/index.xhtml) installation.  In this way, the installation is already declared in the flake configuration.

It may, however, be preferable in the future to use the standalone method as described [here](https://nix-community.github.io/home-manager/index.xhtml#sec-install-standalone) to decouple the system configuration from the Home Manager configuration in the root configuration.

**4. Clone this Repo**

```bash
cd /home/gdenys/
git clone https://github.com/greatwillow/dotfiles.git
```

**5. Modify ./flake.nix as needed to match any differences in UserName, HostName, or Home Path**

**7. Run the Darwin-Rebuild Switch Command**

1. To make updates to the system after modifying a flake:

```bash
% cd ./nix-darwin 
% darwin-rebuild switch --flake .
```

2. If needing to debug the flake, add NIX_DEBUG=1. Note that running the following command without the `switch` statement will terminate the execution.  This is useful for debugging purposes.

```bash
% cd ~/dotfiles 
% NIX_DEBUG=1 darwin-rebuild switch --flake .
```