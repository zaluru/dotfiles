{
  git = {
    ga = "git add";
    gaa = "git add .";
    gap = "git add .";
    gc = "git add --patch";
    gca = "git commit --amend";
    gcg = "git --no-pager log --graph --topo-order --abbrev-commit --date=short --decorate --all --boundary";
    gcl = "git --no-pager log --topo-order --abbrev-commit --date=short --decorate --all --boundary --reverse";
    gco = "git checkout";
    gcob = "git checkout -b";
    gcom = "git checkout main";
    gcm = "git commit --message";
    gd = "git --no-pager diff";
    gD = "git diff";
    gds = "git --no-pager diff --staged";
    gf = "git fetch";
    gfo = "git fetch --origin";
    gfp = "git push --set-upstream origin `git symbolic-ref --short HEAD`";
    gl = "git pull";
    gp = "git push";
    grsh = "git reset --soft HEAD^";
    grh = "git reset";
    grhh = "git reset --hard";
    gru = "git reset --";
    grset = "git remote set-url";
    gsa = "git stash --all";
    gst = "git --no-pager status";
  };

  docker = {
    db = "docker build -t $(whoami)/$(basename $(pwd)):dev .";
    dbnc = "docker build --no-cache -t $(whoami)/$(basename $(pwd)):dev .";
    dr = "docker run -it --rm --name $(basename $(pwd)) $(whoami)/$(basename $(pwd)):dev bash";
    drs = "docker run -it --rm --name $(basename $(pwd)) $(whoami)/$(basename $(pwd)):dev sh";
  };

  eza = {
    ld = "eza -lD --icons --git ";
    lf = "eza -lF --color=always --icons --git  | grep -v /";
    lh = "eza -dl .* --group-directories-first --icons --git ";
    ll = "eza -al --group-directories-first --icons --git ";
    ls = "eza -alF -s type --icons --git";
    lt = "eza -al --sort=modified --icons --git ";
  };

  systemctl = {
    _dst = "sudo systemctl status";
    _dstop = "sudo systemctl stop";
    _drs = "sudo systemctl restart";
    _dstart = "sudo systemctl start";
  };
}
