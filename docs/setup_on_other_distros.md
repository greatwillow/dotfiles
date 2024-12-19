## Setup in Ubuntu and other Linux Distributions

For WSL/Windows, if we use another distro, such as Ubuntu, we need to do the following:

**1. Ensure Git is Installed and Present in the Distro Home**

If using WSL, see [here](https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-git)

**2. Install Nix**

The Windows installation instructions can be found [here](https://nixos.org/download/#nix-install-windows).  Upon last check, the following script could be run to install Nix as a multi-user installation:

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

**3. Install Home-Manager**

Home-manager needs to be installed in this case using the standalone method described [here](https://nix-community.github.io/home-manager/index.xhtml#sec-install-standalone)

**4. Clone this Repo**

```bash
cd /home/gdenys/
git clone https://github.com/greatwillow/dotfiles.git
```

**5. Modify ./flake.nix as needed to match any differences in UserName, HostName, or Home Path**

**6. Ensure that apps such as Docker and VSCode will work Properly**

If in WSL, see [here](https://learn.microsoft.com/en-us/windows/wsl/setup/environment)

**7. Run the Home-Manager Switch Command**

```bash 
% home-manager switch -b backup --extra-experimental-features 'nix-command' --extra-experimental-features 'flakes' --flake ./flake.nix#myUser@myHost --impure
```

## Additional WSL Notes

#### How To Setup User and Login
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

#### How to Login with new user
- Find Linux Distro that want to use: `wsl -l -v`
- Login to WSL with that user ie. `wsl -d Ubuntu-20.04 -u gdenys`

#### How to Setup Nix Daemon

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