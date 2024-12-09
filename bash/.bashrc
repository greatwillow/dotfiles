SHELLS_COMMON_CONFIG_DIRECTORY="$HOME/.config/_common"
EXPORTS_PATH="$SHELLS_COMMON_CONFIG_DIRECTORY/posix_exports"
ALIASES_PATH="$SHELLS_COMMON_CONFIG_DIRECTORY/posix_aliases"

# Import Exports
source [[ -f $EXPORTS_PATH ]] && source $EXPORTS_PATH
# Import Aliases
source [ -f $ALIASES_PATH ] && source $ALIASES_PATH
