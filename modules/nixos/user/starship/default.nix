{ lib, config, ... }:
let

  inherit (lib) mkIf;
  cfg = config.mine.user.shell.starship;
  langs = "$aws$python$terraform$vagrant";

in
{
  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
        command_timeout = 5000;
        format = ''
          $directory$shell$all
        '';
        character = {
          success_symbol = "[ ](bold #cba6f7)[ ](bold #f2cdcd)[󰮯 ](bold #b4befe)[ ](bold #a6e3a1)";
          error_symbol = "[ ](bold #cba6f7)[ ](bold #f2cdcd)[󰮯 ](bold #b4befe)[ ](bold #f38ba8)";
          vimcmd_symbol = "[ NORMAL](bold #fab387)";
          vimcmd_visual_symbol = "[ VISUAL](bold #89dceb)";
        };

        shell = {
          disabled = false;
          format = "[$indicator](#cba6f7 bold) ";
          fish_indicator = " 󰈺 ";
          bash_indicator = "  ";
          powershell_indicator = " 󰨊 ";
        };

        direnv = {
          disabled = false;
          format = "[ $symbol$loaded$denied  ]($style)";
          style = "fg:#FF8700";
          symbol = " ";
          allowed_msg = "";
          loaded_msg = "";
          not_allowed_msg = "";
          denied_msg = "";
          unloaded_msg = "";
        };

        python = {
          disabled = false;
          format = "[ $symbol$pyenv_prefix($version)($virtualenv) ]($style)";
          symbol = " ";
          style = "fg:#81A2BE";
        };

        aws = {
          disabled = false;
          format = "[ $symbol($profile)$region ]($style)";
          symbol = "  ";
          style = "fg:#81A2BE";
        };

        vagrant = {
          disabled = false;
          format = "[ $symbol($version) ]($style)";
          symbol = " ";
          style = "fg:#81A2BE";
        };

        terraform = {
          disabled = false;
          format = "[ $symbol($workspace) ]($style)";
          symbol = " ";
          style = "fg:#81A2BE";
        };

        status = {
          style = "italic";
          disabled = false;
          symbol = "[](fg:#D54E53)";
          success_symbol = "[](fg:#A7AF63)";
          format = "[$int]($style)";
        };

        sudo = {
          disabled = true;
          format = "[$symbol]($style)";
          style = "red";
          symbol = "󰀨 ";
        };

        cmd_duration = {
          disabled = false;
          format = "[  $duration  ]($style)";
          style = "fg:#F0C674";
        };

        nix_shell = {
          disabled = false;
          style = "fg:#FFD687";
          symbol = " ";
          format = "[$symbol$state ]($style)";
        };

        git_branch = {
          symbol = " ";
        };

        git_status = {
          modified = "";
          untracked = "";
          staged = "";
        };

        directory = {
          format = "[$path]($style)";
          truncate_to_repo = false;
          truncation_length = 5;
          truncation_symbol = "…/";
        };
      };
    };
  };
}
