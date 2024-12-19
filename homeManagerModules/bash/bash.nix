{
		pkgs,
		shellAliases,
		homeManagerModulesPath,
		...
}: {
		bash = {
			enable = true;
			shellAliases = shellAliases;
		};
}
