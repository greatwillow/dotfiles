# dotfiles
My personal home configurations

## Usage

### Darwin/Mac

1. To make updates to the system after modifying a flake:
   
```bash
% cd ./nix-darwin 
% darwin-rebuild switch --flake .
```

2. If needing to debug the flake, add NIX_DEBUG=1. Note that running the following command without the `switch` statement will terminate the execution.  This is useful for debugging purposes.

```bash
% cd ./nix-darwin 
% NIX_DEBUG=1 darwin-rebuild switch --flake .
```

### WSL/Windows - Other Distro

For WSL/Windows, if we use another distro, such as Ubuntu, we need to do the following:

#### Setup User and Login
- Find Linux Distro that want to use: `wsl -l -v`
- Login without particular user (will be root) `wsl -d Ubuntu-20.04`
- Add  user that corresponds to root folder (ie. `gdenys`) and add user to the sudoers file

```bash
# Add a new user with a specific home directory
sudo adduser --home /mnt/c/Users/MyUser myuser

# Open the sudoers file to add the user to the sudoers list
sudo visudo
# Add the following line in the sudoers file:
# myuser ALL=(ALL) ALL

# Change the ownership of the home directory to the new user
sudo chown -R myuser:myuser /mnt/c/Users/MyUser

# Add the user to the nix-users group (if necessary)
sudo usermod -aG nix-users myuser

# Switch to new user
su - myuser

# Run a command with sudo to verify access:
sudo whoami  # Output should be root, indicating that the user has sudo privileges.
```

#### Login with new user
- Find Linux Distro that want to use: `wsl -l -v`
- Login to WSL with that user ie. `wsl -d Ubuntu-20.04 -u gdenys`

#### Install Nix

The Windows installation instructions can be found [here](https://nixos.org/download/#nix-install-windows).  Upon last check, the following script could be run to install Nix as a multi-user installation:

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

#### Install Home-Manager

Home-manager needs to be installed in this case using the standalone method described [here](https://nix-community.github.io/home-manager/index.xhtml#sec-install-standalone)

#### Setup Nix Daemon

For multi-user installation, a Nix Daemon needs to be run.  Normally this is automated by Nix via the above script, however, there are issues with this in WSL and the following needs to be completed:

**Step 1: Create a Nix Daemon Service Script**

1. Create a new script file, for example, start-nix-daemon.sh:
```bash
sudo vim /usr/local/bin/start-nix-daemon.sh
```
2. Add the following content to the script:
```bash
#!/bin/sh
if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi
sudo /nix/var/nix/profiles/default/bin/nix-daemon &
```
3. Save the file and exit the editor.
4. Make the script executable:
```bash
sudo chmod +x /usr/local/bin/start-nix-daemon.sh
```

**Step 2: Start the Nix Daemon Manually**
```vim
sudo /usr/local/bin/start-nix-daemon.sh
```

**Step 3: Add the Script to Your Shell Configuration**
Add the following line to the `~/.zshrc` file:
```bash
/usr/local/bin/start-nix-daemon.sh
```

#### Refresh Command
   
```zsh 
% home-manager switch -b backup -f /mnt/c/Users/GregoryDenys/dotfiles/home/linux/home.nix
```

### WSL/NixOS

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

## System Names

- **artemis** - The local macbook pro
- **apollo** - The work computer

## Usage of Configured Libraries

### Nushell

**Issues** 
There was an issue with starting nushell where it does not point by default to the config file located at `~/.config/nushell/config.nu`.  To resolve this, it is necessary to start nushell with the command `nu --config ~/.config/nushell/config.nu` rather than the standard `nu` command.  This is the way that nushell is being started from within ITerm2.  See [this](https://github.com/nushell/nushell/discussions/5279) thread for more context.

### Oh My Posh

**Theming**
For OMP themes, go [here](https://ohmyposh.dev/docs/themes)

**Issues**
OMP is initialized in the bottom of the `env.nu` file with the following script:

`oh-my-posh init nu --config ~/.config/oh-my-posh/themes/catppuccin_mocha.omp.json --print | save ~/oh-my-posh-init.nu --force`

Here, OMP is taking the catpuccin_mocha theme config and saving it with an autogenerated initialization script `oh-my-posh-init.nu`.  In this special case, we are accessing this file from the user root directory instead of the `.config` directory.  This is because there were some issue with OMP writing to the `.config` directory.  

**Manual Steps**
An important note here is that the `~/oh-my-posh-init.nu` file must be created manually to allow this file to be written to.  This is because there were issues making this work in nushell.  Note also that the terminal may need to be opened twice initially before the initial config takes effect.
Also, note that the Nix installed Nerd Font may need to be set up to be used in the given terminal emulator to allow for OMP to work properly. 

### NeoVim

**Manual Steps**
The folder `/Users/gdenys/.local/share/nvim` needs to be manually created for nvim to work.  Currently the activation script inside `home.nix` is not working to create this automatically.
