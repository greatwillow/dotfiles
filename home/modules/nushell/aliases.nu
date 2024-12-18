
# Easier navigation: .., ..., ~ and -
alias .. = cd ..
alias ... = cd ../..
alias .... = cd ../../..
alias ..... = cd ../../../..
alias ~ = cd ~ # `cd` is probably faster to type though

alias nnotes = cd "~/Library/Mobile\\ Documents/iCloud~md~obsidian/Documents/ObsidianNotes"
alias ncomp = cd "~/Desktop/Comp\\ Sci"
alias ndesk = cd "~/Desktop"
alias ndot = cd "~/dotfiles"

# -------------------- List Files --------------------
alias l = eza -l --icons --git -a
alias ls =  eza
alias ll =  eza -l
alias la =  eza -a
alias lla = eza -la
alias lt = eza --tree --level=2 --long --icons --git
alias ltree = eza --tree --level=2  --icons --git

def --env cx [arg] {
    cd $arg
    ls -l
}
# -------------------- Manage Files --------------------

# mv, rm, cp
alias md = mkdir
alias mv = mv -i -v
alias rm = rm -i -v
alias cp = cp -v

# Git
alias gs = git status
alias ga = git add
alias gaa = git add -A
alias gcm = git commit -m
alias gf = git fetch
alias gco = git checkout
alias gcob = git checkout -b 
alias gl = git log
alias glog = git log --oneline --graph
alias gbl = git branch --list
alias gpr = git pull --rebase
alias gp = git push
alias gpf = git push --force-with-lease
alias gss = git stash save
alias gsl = git stash list
alias gsp = git stash pop
alias grm = git rebase main
alias grc = git rebase --continue

def set-xdg-home [] {
    $env.XDG_CONFIG_HOME = ($env.HOME + "/.config")
	echo $env.XDG_CONFIG_HOME
}

# Nix
def refresh-pure [] {
    ndarwin
	set-xdg-home
    with-env {NIX_DEBUG: "1"} { darwin-rebuild switch --flake . }
}

def refresh [] {
    ndarwin
	set-xdg-home
    with-env {NIX_DEBUG: "1"} { darwin-rebuild switch --impure --flake . }
}

set-xdg-home

echo "\n>>>> aliases.nu loaded\n"
