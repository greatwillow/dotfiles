# dotfiles
My personal home configurations

## Usage

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

## Usage of Configured Libraries

### Nushell

**Problem** - There was an issue with starting nushell where it does not point by default to the config file located at `~/.config/nushell/config.nu`.  To resolve this, it is necessary to start nushell with the command `nu --config ~/.config/nushell/config.nu` rather than the standard `nu` command.  This is the way that nushell is being started from within ITerm2.