### Nushell

**Issues** 
There was an issue with starting nushell where it does not point by default to the config file located at `~/.config/nushell/config.nu`.  To resolve this, it is necessary to start nushell with the command `nu --config ~/.config/nushell/config.nu` rather than the standard `nu` command.  This is the way that nushell is being started from within ITerm2.  See [this](https://github.com/nushell/nushell/discussions/5279) thread for more context.

