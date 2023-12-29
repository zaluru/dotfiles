{ ... }:

{
  programs.nushell = {
    enable = true;
    extraConfig = 
      "$env.config.table.header_on_separator = true\n
      $env.config.show_banner = false";
  };
}
