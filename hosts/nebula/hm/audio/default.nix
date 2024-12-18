{ ... }:

{
  # https://wiki.archlinux.org/title/WirePlumber
  # usefull commands
  # wpctl status
  # wpctl info <id> - here you can find the device.name or node.name and add rules by matching them

  xdg.configFile."wireplumber" = {
    source = ./wireplumber;
    recursive = true;
  };
}
