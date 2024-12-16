{
	pkgs,
	shellAliases,
	...
}: {
	bash = {
		enable = true;
		shellAliases = shellAliases;
	};
}
