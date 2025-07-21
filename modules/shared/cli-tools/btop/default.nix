{
  pkgs,
  lib,
  config,
  ...
}:
let

  inherit (lib) mkIf types;
  inherit (lib.zaluru) mkOpt;
  inherit (config.mine) user;
  cfg = config.mine.cli-tools.btop;

in
{
  options.mine.cli-tools.btop = {
    enable = mkOpt types.bool false "Enable btop, a terminal based system monitor.";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user.name} = {
      programs.btop = {
        enable = true;

        settings = {
          color_theme = "oxocarbon_dark";
          #theme_background = false;
        };

        themes = {
          oxocarbon_dark = ''
            # Source: https://gist.github.com/gideonmt/cf8561cb130e3ca859f8a5471014e933
            # Based Oxocarbon Dark by Nyoom Engineering https://github.com/nyoom-engineering
            
            # Main background, empty for terminal default, need to be empty if you want transparent background
            theme[main_bg]="#161616"
            
            # Main text color
            theme[main_fg]="#f2f4f8"
            
            # Title color for boxes
            theme[title]="#3ddbd9"
            
            # Highlight color for keyboard shortcuts
            theme[hi_fg]="#78a9ff"
            
            # Background color of selected items
            theme[selected_bg]="#262626"
            
            # Foreground color of selected items
            theme[selected_fg]="#08bdba"
            
            # Color of inactive/disabled text
            theme[inactive_fg]="#393939"
            
            # Color of text appearing on top of graphs, i.e uptime and current network graph scaling
            theme[graph_text]="#525252"
            
            # Misc colors for processes box including mini cpu graphs, details memory graph and details status text
            theme[proc_misc]="#42be65"
            
            # Cpu box outline color
            theme[cpu_box]="#dde1e6"
            
            # Memory/disks box outline color
            theme[mem_box]="#dde1e6"
            
            # Net up/down box outline color
            theme[net_box]="#dde1e6"
            
            # Processes box outline color
            theme[proc_box]="#dde1e6"
            
            # Box divider line and small boxes line color
            theme[div_line]="#525252"
            
            # Temperature graph colors
            theme[temp_start]="#08bdba"
            theme[temp_mid]="#3ddbd9"
            theme[temp_end]="#78a9ff"
            
            # CPU graph colors
            theme[cpu_start]="#42be65"
            theme[cpu_mid]="#be95ff"
            theme[cpu_end]="#ee5396"
            
            # Mem/Disk free meter
            theme[free_start]="#08bdba"
            theme[free_mid]=""
            theme[free_end]="#3ddbd9"
            
            # Mem/Disk cached meter
            theme[cached_start]="#78a9ff"
            theme[cached_mid]=""
            theme[cached_end]="#33b1ff"
            
            # Mem/Disk available meter
            theme[available_start]="#42be65"
            theme[available_mid]=""
            theme[available_end]="#be95ff"
            
            # Mem/Disk used meter
            theme[used_start]="#ee5396"
            theme[used_mid]=""
            theme[used_end]="#ff7eb6"
            
            # Download graph colors
            theme[download_start]="#08bdba"
            theme[download_mid]="#3ddbd9"
            theme[download_end]="#78a9ff"
            
            # Upload graph colors
            theme[upload_start]="#ee5396"
            theme[upload_mid]="#ff7eb6"
            theme[upload_end]="#be95ff"
          '';
        };
      };
    };
  };
}
