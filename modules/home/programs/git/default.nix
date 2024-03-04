{ username, ... }:

{
  programs.git = {
    enable = true;
    userName = "${username}";
    userEmail = "zaluru@zaluru.com";

    includes = [
      {
        condition = "gitdir:~/dev/work/";
        path = "~/.config/git/work.inc";
      }
    ];
  };
}
