
# Easier navigation: .., ..., ~ and -
alias .. = cd ..
alias ... = cd ../..
alias .... = cd ../../..
alias ..... = cd ../../../..
alias ~ = cd ~ # `cd` is probably faster to type though

alias ndarwin = cd ~/dotfiles/nix-darwin

def --env cx [arg] {
    cd $arg
    ls -l
}

# mv, rm, cp
alias mv = mv -v
alias rm = rm -i -v
alias cp = cp -v

# Git
alias gs = git status
alias gcm = git commit -m
alias gaa = git add -A
alias gf = git fetch
alias gss = git stash save

def set-xdg-home [] {
    $env.XDG_CONFIG_HOME = ($env.HOME + "/.config")
	echo $env.XDG_CONFIG_HOME
}

# Nix
def nix-refresh [] {
    ndarwin
	set-xdg-home
    with-env {NIX_DEBUG: "1"} { darwin-rebuild switch --flake . }
}

def nix-refresh-impure [] {
    ndarwin
	set-xdg-home
    with-env {NIX_DEBUG: "1"} { darwin-rebuild switch --impure --flake . }
}

set-xdg-home

echo "\n>>>> aliases.nu loaded\n"
