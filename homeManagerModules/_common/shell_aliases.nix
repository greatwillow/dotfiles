{
  pkgs,
  homeManagerModulesPath,
  ...
}:
let
  editor = "nvim";
  apolloRefreshCommand = "home-manager switch -b backup --extra-experimental-features 'nix-command' --extra-experimental-features 'flakes' --flake $HOME/dotfiles/flake.nix#gdenys@PF-B58J3T3";
  artemisRefreshCommand = "NIX_DEBUG=1 darwin-rebuild switch --flake $HOME/dotfiles/flake.nix";
  shellAliases = {

    # -------------------- Shell --------------------
    edit = "vim ~/dotfiles/nix-darwin/home.nix";

    apollo-refresh-pure = "${apolloRefreshCommand}";
    apollo-refresh = "${apolloRefreshCommand} --impure";
    artemis-refresh-pure = "${artemisRefreshCommand}";
    artemis-refresh = "${artemisRefreshCommand} --impure";

    # -------------------- Navigation --------------------
    ".." = "cd ..";
    "cd.." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";
    "~" = "cd ~"; # `cd` is probably faster to type though
    c = "clear";
    cat = "bat --paging=never";
    # Always enable colored `grep` output
    # Note: `GREP_OPTIONS=\"--color=auto\"` is deprecated, hence the alias usage.
    grep = "grep --color=auto";

    # -------------------- Filesystem --------------------
    nnotes = "cd $HOME/Library/Mobile\\ Documents/iCloud~md~obsidian/Documents/ObsidianNotes";
    ncomp = "cd $HOME/Desktop/Comp\\ Sci";
    ndesk = "cd $HOME/Desktop";
    ndot = "cd $HOME/dotfiles";

    # -------------------- List Files --------------------
    l = "eza -l --icons --git -a";
    ls = "eza";
    ll = "eza -l";
    la = "eza -a";
    lla = "eza -la";
    lt = "eza --tree --level=2 --long --icons --git";
    ltree = "eza --tree --level=2  --icons --git";

    # -------------------- Manage Files --------------------
    md = "mkdir -p";
    mv = "mv -i";
    cp = "cp -v";
    rm = "rm -i -v";
    sdn = "sudo shutdown -h now";
    shutdown = "umount -R /mnt/ ; sudo shutdown -h now";

    # -------------------- System --------------------
    # Lock the screen (when going AFK)
    afk = "/System/Library/CoreServices/Menu\\ Extras/User.menu/Contents/Resources/CGSession -suspend";

    # Show/hide hidden files in Finder
    show = "defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder";
    hide = "defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder";

    # Print each PATH entry on a separate line
    path = "echo -e $(echo $PATH | tr ':' '\\n')";

    # -------------------- Shell --------------------
    # Reload the shell (i.e. invoke as a login shell)
    reload = "exec ${builtins.getEnv "SHELL"} -l";
    # Shows the shell of the current process whereas echo $SHELL shows the default login shell
    shell = "ps -p $$ -o comm=";

    # -------------------- Editor --------------------
    vim = "${editor}"; # use neovim instead of vim
    vimrc = "vim ${builtins.getEnv "HOME"}/.config/nvim/init.vim"; # open vim config from anywhere
    vimdiff = "${editor} -d";
    x = "exit";

    # -------------------- Specific Programs --------------------
    # Zellij
    zel = "${pkgs.zellij}/bin/zellij";

    # npm
    list-npm-globals = "npm list -g --depth=0"; # List out all globally installed npm packages

    # pnpm
    rw = "pnpm webpack";
    rww = "pnpm webpack-watch";
    red = " pnpm execute-development";
    redw = "pnpm execute-development-watch";
    rs = "pnpm storybook";
    ee = "vim \"$APPDATA/espanso/match/base.yml\"";
    pba = "pnpm build:all";
    psa = "pnpm start:all";
    pt = "pnpm test";
    ptd = ''
      
            
                  
                        
                              
                                    
                                                        function ptd() {
                                                            pnpm test:code --dir "$1"
                                                        }
    '';

    # Ensures that opening nushell will point to the correct config file
    nu = "nu --config ${homeManagerModulesPath}/nushell/config.nu";

    # Dotnet
    # # stops all dotnet processes.  NOTE: Only works in Powershell
    # alias stopdotnet="taskkill /im dotnet.exe /f"

    # Youtube
    yt-dl = "yt-dlp --format \"bestvideo+bestaudio[ext=m4a]/bestvideo+bestaudio/best\" --merge-output-format mp4";
    ytplaylist = "yt-dlp -i -f mp3 --yes-playlist --add-metadata";

    # -------------------- Git --------------------
    lg = "lazygit";
    gs = "git status";
    ga = "git add";
    gaa = "git add -A";
    gcm = "git commit -m";
    gf = "git fetch";
    gco = "git checkout";
    gcob = "git checkout -b";
    gl = "git log";
    glog = "git log --oneline --graph";
    gbl = "git branch --list";
    gpr = "git pull --rebase";
    gp = "git push";
    gpf = "git push --force-with-lease";
    gss = "git stash save";
    gsl = "git stash list";
    gsp = "git stash pop";
    grm = "git rebase main";
    grc = "git rebase --continue";

    # g = "git";
    # gr = "git restore";
    # gam = "git am";
    # gama = "git am --abort";
    # gamc = "git am --continue";
    # gams = "git am --skip";
    # gamscp = "git am --show-current-patch";
    # gap = "git apply";
    # gapa = "git add --patch";
    # gapt = "git apply --3way";
    # gau = "git add --update";
    # gav = "git add --verbose";
    # gbl = "git blame -b -w";
    # gbs = "git bisect";
    # gbsb = "git bisect bad";
    # gbsg = "git bisect good";
    # gbsr = "git bisect reset";
    # gbss = "git bisect start";
    # gc = "git commit --verbose";
    # "gc!" = "git commit --verbose --amend";
    # gca = "git commit --verbose --all";
    # "gca!" = "git commit --verbose --all --amend";
    # gcam = "git commit --all --message";
    # "gcan!" = "git commit --verbose --all --no-edit --amend";
    # "gcans!" = "git commit --verbose --all --signoff --no-edit --amend";
    # gcas = "git commit --all --signoff";
    # gcasm = "git commit --all --signoff --message";
    # gcb = "git checkout -b";
    # gcd = "git checkout $(git_develop_branch)";
    # gcf = "git config --list";
    # gcl = "git clone --recurse-submodules";
    # gclean = "git clean --interactive -d";
    # gcm = "git commit -m";
    # gcmsg = "git commit --message";
    # "gcn!" = "git commit --verbose --no-edit --amend";
    # gco = "git checkout";
    # gcob = "git checkout -b";
    # gcor = "git checkout --recurse-submodules";
    # gcount = "git shortlog --summary --numbered";
    # gcp = "git cherry-pick";
    # gcpa = "git cherry-pick --abort";
    # gcpc = "git cherry-pick --continue";
    # gcs = "git commit --gpg-sign";
    # gcsm = "git commit --signoff --message";
    # gcss = "git commit --gpg-sign --signoff";
    # gcssm = "git commit --gpg-sign --signoff --message";
    # gd = "git diff";
    # gdca = "git diff --cached";
    # gdct = "git describe --tags $(git rev-list --tags --max-count=1)";
    # gdcw = "git diff --cached --word-diff";
    # gds = "git diff --staged";
    # gdt = "git diff-tree --no-commit-id --name-only -r";
    # gdup = "git diff @{upstream}";
    # gdw = "git diff --word-diff";
    # gf = "git fetch";
    # gfa = "git fetch --all --prune --jobs=10";
    # gfg = "git ls-files | grep";
    # gfo = "git fetch origin";
    # ggsup = "git branch --set-upstream-to=origin/$(git_current_branch)";
    # gignore = "git update-index --assume-unchanged";
    # git-svn-dcommit-push = "git svn dcommit && git push github $(git_main_branch):svntrunk";
    # gl = "git pull";
    # glg = "git log --graph --oneline --decorate --all";
    # glgg = "git log --graph";
    # glgga = "git log --graph --decorate --all";
    # glgm = "git log --graph --max-count=10";
    # glgp = "git log --stat --patch";
    # glo = "git log --oneline --decorate";
    # globurl = "noglob urlglobber ";
    # lp = "_git_log_prettily";
    # gluc = "git pull upstream $(git_current_branch)";
    # glum = "git pull upstream $(git_main_branch)";
    # gma = "git merge --abort";
    # gs = "git status";
    # gmom = "git merge origin/$(git_main_branch)";
    # gms = "git merge --squash";
    # gmum = "git merge upstream/$(git_main_branch)";
    # gp = "git push";
    # gpd = "git push --dry-run";
    # gpf = "git push --force-with-lease --force-if-includes";
    # "gpf!" = "git push --force";
    # gpl = "git pull";
    # gpu = "git push upstream";
    # gpv = "git push --verbose";

    # # checks for any files flagged w/ --skip-worktree alias
    # alias checkskip="git ls-files -v|grep '^S'"

    # # add --skip-worktree flag to file
    # skip() {  git update-index --skip-worktree "$@";  git status; }
    # # remove --skip-worktree flag from file
    # unskip() {  git update-index --no-skip-worktree "$@";  git status; }
  };
in
{
  shellAliases = shellAliases;
}
