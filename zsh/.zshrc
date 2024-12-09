BASE_CONFIG_DIRECTORY="$HOME/.config"
SHELLS_COMMON_CONFIG_DIRECTORY="$BASE_CONFIG_DIRECTORY/sh"
SHELL_ALIASES_DIRECTORY="$SHELLS_COMMON_CONFIG_DIRECTORY/.aliases"
SHELL_EXPORTS_DIRECTORY="$SHELLS_COMMON_CONFIG_DIRECTORY/.exports"
ZSH_CONFIG_DIRECTORY="$BASE_CONFIG_DIRECTORY/zsh"
ZSH_PLUGINS_DIRECTORY="$ZSH_CONFIG_DIRECTORY/plugins"
ZSH_PLUGINS_CONFIG_PATH="$ZSH_PLUGINS_DIRECTORY/.zsh_plugins.sh"
ANTIDOTE_CONFIG_DIRECTORY="$BASE_CONFIG_DIRECTORY/antidote"
NIX_SHELL_CONFIG_PATH="~/.nix-profile/etc/profile.d/nix.sh"
ASDF_CONFIG_DIRECTORY="$HOME/.config/asdf"
ASDF_SHELL_CONFIG_PATH="$ASDF_CONFIG_DIRECTORY/asdf.sh"
POWERLEVEL10K_CONFIG_DIRECTORY="$BASE_CONFIG_DIRECTORY/powerlevel10k"

# The following line would be needed ABOVE the powerlevel script below to enable direnv
# (( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source Nix profile to add Nix-installed binaries to PATH
if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# The following line would be needed BELOW the powerlevel script above to enable direnv
# (( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"

# Antidote -> https://getantidote.github.io/
# clone antidote if necessary
[[ -e $ANTIDOTE_CONFIG_DIRECTORY ]] || git clone https://github.com/mattmc3/antidote.git $ANTIDOTE_CONFIG_DIRECTORY
# source antidote
source $ANTIDOTE_CONFIG_DIRECTORY/antidote.zsh
# generate and source plugins from $ZSH_CONFIG_DIRECTORY/.zsh_plugins.txt
antidote load $ZSH_PLUGINS_CONFIG_PATH

export XDG_CONFIG_HOME="$HOME/.config"

# Zsh History exports and settings
export HISTFILE=$ZDOTDIR/.zhistory      # History filepath
export HISTSIZE=10000                   # Maximum events for internal history
export HISTTIMEFORMAT="%d/%m/%y %T "	# History format with time added
export SAVEHIST=10000                   # Maximum events in history file
setopt HIST_IGNORE_ALL_DUPS # History won't save duplicates.
setopt HIST_FIND_NO_DUPS # History won't show duplicates on search.

# Import Plugins
[ -f $ZSH_PLUGINS_DIRECTORY ] && source $ZSH_PLUGINS_DIRECTORY
# Import Aliases
[ -f $SHELL_ALIASES_DIRECTORY ] && source $SHELL_ALIASES_DIRECTORY
# Import Exports
[ -f $SHELL_EXPORTS_DIRECTORY ] && source $SHELL_EXPORTS_DIRECTORY

if [[ IS_WINDOWS_OS == "false" ]]; then
  # Import ASDF 
  [[ -e $ASDF_SHELL_CONFIG_PATH ]] && source $ASDF_SHELL_CONFIG_PATH
  # Add ASDF completions to PATH
  fpath=(${ASDF_DIR}/completions $fpath)
fi

# Import Nix
[[ -e $NIX_SHELL_CONFIG_PATH ]] && source $NIX_SHELL_CONFIG_PATH

# Completions
autoload -U compinit; compinit	# Activates completions

# Import PowerLevel10k -> To customize prompt, run `p10k configure` or edit ~/p10k.zsh.
[ ! -f $POWERLEVEL10K_CONFIG_DIRECTORY/p10k.zsh ] || source $POWERLEVEL10K_CONFIG_DIRECTORY/p10k.zsh
[ ! -f $POWERLEVEL10K_CONFIG_DIRECTORY/powerlevel10k.zsh-theme ] || source $POWERLEVEL10K_CONFIG_DIRECTORY/powerlevel10k.zsh-theme
