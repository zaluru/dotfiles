{...}: 
{
  imports =
    [(import ./hyprland)] ++
    [(import ./dunst)] ++
    [(import ./waybar)] ++
    [(import ./tofi)] ++
    [(import ./variables.nix)];
}
