
{
  pkgs,
  ...
}: let
  editor = "nvim";
  shellAliases = {


	# alias rw="pnpm webpack"
	# alias rww="pnpm webpack-watch"
	# alias red="pnpm execute-development"
	# alias redw="pnpm execute-development-watch"
	# alias rs="pnpm storybook"
	# alias ee="vim \"$APPDATA/espanso/match/base.yml\""
	# alias pba="pnpm build:all"
	# alias psa="pnpm start:all"
	# alias pt="pnpm test"
	# alias ptd="pnpm test:code --dir ${1}"
	# # checks for any files flagged w/ --skip-worktree alias
	# alias checkskip="git ls-files -v|grep '^S'"
	# # stops all dotnet processes.  NOTE: Only works in Powershell
	# alias stopdotnet="taskkill /im dotnet.exe /f"
	# # add --skip-worktree flag to file
	# skip() {  git update-index --skip-worktree "$@";  git status; }
	# # remove --skip-worktree flag from file
	# unskip() {  git update-index --no-skip-worktree "$@";  git status; }

	# -------------------- Shell --------------------
	# alias edit="vim ~/.bashrc"
	# alias restart="source ~/.bashrc"
	# alias src=". ~/.bashrc"

	# -------------------- Navigation --------------------
    ".." = "cd ..";
    "..." = "cd ..; cd ..";
    c = "clear";
    cat = "bat";
    zel = "${pkgs.zellij}/bin/zellij";

	# -------------------- Git --------------------
	gs = "git status";
	gaa = "git add -A";
	gcm = "git commit -m ${1}";
	gco = "git checkout ${1}";
	gcob = "git checkout -b ${1}";
	gl = "git log";
	glog = "git log --oneline --graph";
	gpr = "git pull --rebase";
	gps = "git push";
	gpf = "git push --force-with-lease";
	gss = "git stash push --staged -m ${1}";
	grm = "git rebase main";
	grc = "git rebase --continue";

    # g = "git";
    # ga = "git add";
    # gaa = "git add --all";
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
	# -------------------- List Files --------------------
    lg = "lazygit";
    ls = "eza";
    ll = "eza -l";
    la = "eza -a";
    lt = "eza --tree";
    lla = "eza -la";
	# -------------------- Manage Files --------------------
    md = "mkdir -p";
    mv = "mv -i";
    sdn = "sudo shutdown -h now";
    shutdown = "umount -R /mnt/ ; sudo shutdown -h now";
	# -------------------- Editor --------------------
    vim = "${editor}";
    vimdiff = "${editor} -d";
    x = "exit";
	# -------------------- Youtube --------------------
    yt-dl = "yt-dlp --format \"bestvideo+bestaudio[ext=m4a]/bestvideo+bestaudio/best\" --merge-output-format mp4";
    ytplaylist = "yt-dlp -i -f mp3 --yes-playlist --add-metadata";
  };
in {
  shellAliases = shellAliases;
}