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