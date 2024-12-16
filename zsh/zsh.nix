{
  pkgs,
  shellAliases,
  ...
}: 

{
	zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;
		syntaxHighlighting.highlighters = [
			"main"
			"brackets"
		];
		shellAliases = shellAliases;	
		history = {
			size = 100000;
			# substringSearch.enable = true;
		};
		antidote.enable = true;
		antidote.plugins = [
				"zsh-users/zsh-autosuggestions"
				"jeffreytse/zsh-vi-mode"
		];	
		initExtra = ''
			if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
				eval "$(oh-my-posh init zsh --config ~/dotfiles/oh-my-posh/themes/catppuccin_mocha.omp.json)"
			fi
		'';
	};
}