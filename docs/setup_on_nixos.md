## Setup in NixOS

The following notes were taken upon attempting to setup an environment in NixOS.  There were issues along the way, and considering there was not much benefit over using this setup at the moment in comparison to using home-manager exclusively in another distribution such as Ubuntu, the attempt was abandoned with some learnings below if this is picked up again in the future.

After Downloading and Installing NixOS as a WSL distribution, login to NixOS with `wsl -d NixOS` and do the following:

#### Setup User and Login

**Step 1: Edit the NixOS Configuration File**
1. Open the NixOS configuration file:
```bash
sudo nano /etc/nixos/configuration.nix
```
2. Add a new user configuration to the file. For example, to add a user myuser with a specific home directory and sudo privileges, add the following lines:
```nix
{ config, pkgs, ... }:

{
  # Other configurations...

  users.users.myuser = {
    isNormalUser = true;
    home = "/mnt/c/Users/MyUser";
    extraGroups = [ "wheel" ];  # Add to the wheel group for sudo access
    shell = pkgs.zsh;  # Set the default shell to zsh
  };

  # Allow members of the wheel group to use sudo
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;  # Set to true if you want to require a password
  };

  # Other configurations...
}
```
**Step 2: Rebuild and Finish User Setup**
```bash
sudo nixos-rebuild switch

# Set a password for the user
sudo passwd myuser

# Switch to the user
su - myuser

# Run a command with sudo to verify access:
sudo whoami  # Output should be root, indicating that the user has sudo privileges.
```

#### Add Nix Experimental Features to Config
1. Make sure that flakes are enabled in your Nix configuration. Add the following lines to your /etc/nixos/configuration.nix:
```nix
{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
```
2. `sudo nixos-rebuild switch`

#### Run Flake Command
1. Navigate to the directory containing your flake.nix file:
```bash
cd /path/to/your/flake
```
2. Run the nixos-rebuild command with the --flake option:
```bash
sudo nixos-rebuild switch --flake .
```

## Nix Packages Garbage Cleanup

```bash
sudo nix-collect-garbage --delete-older-than 15d
```

## Nix Flake Creation from Template

```bash
sudo nix flake init --template github:vimjoyer/flake-starter-config
```

## Nix Package Location

Nix places packages in `/nix/store` and links to those on a per user basis inside of ` /etc/profiles/per-user/$USER/` where $USER may be `myUserName`.  When things are set up properly, the `~/.nix-profile` file is symlinked to this folder.  It was once observed that this had changed and was no longer the case.  In such a case, the following commands need to be run:

1. `rm ~/.nix-profile`
2. `ln -s /etc/profiles/per-user/$USER/ ~/.nix-profile`

and then the path `~/.nix-profile/bin` needs to be added to `$PATH`