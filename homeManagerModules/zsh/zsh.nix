{
  	pkgs,
  	shellAliases,
		homeManagerModulesPath,
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
				initExtra = builtins.replaceStrings ["\r\n"] ["\n"] ''
						if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
								eval "$(oh-my-posh init zsh --config ${homeManagerModulesPath}/oh_my_posh/themes/catppuccin_mocha.omp.json)"
						fi
				'';
		};
}