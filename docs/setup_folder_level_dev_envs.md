## Setup Folder Level Dev Environments

**Nix-Shell** and **Direnv** can be used in combination to set up folder level development environments.  To do so, follow these steps:

1. Create a .gitignore_global file if it doesn't already exist in the home directory (~).
   
2. Add `.envrc`, and `shell.nix` to this file.
   
3. Register the .gitignore_global file with git.

```sh
	git config --global core.excludesfile ~/.gitignore_global
```

4. Go into the specific project directory and create a `.envrc` file and a `shell.nix` file.  If it is intended that these files should be persisted in the given repository, the local global gitignore specification can be overridden in the local gitignore by adding `!.envrc` and/or `!shell.nix`.

5. Add the line `use nix` inside the `.envrc` file.

6. Inside the `shell.nix` file, logic needs to be added for that environment.  Information such as the buildInputs and other custom logic such as environment variables can be setup.  Look online for the format, though in general it will be something like:

```nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
	buildInputs = [
		pkgs.myPackage1
	];

	shellHook = ''
		export MY_ENV_VAR = "something"
	'';
}
```