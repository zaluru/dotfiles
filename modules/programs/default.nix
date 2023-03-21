{...}: 
{
  imports = 
    [(import ./kitty)] ++
    [(import ./alacritty)] ++
    [(import ./neofetch)] ++
    [(import ./neovim)] ++
    [(import ./fish)] ++
    [(import ./starship)] ++
    [(import ./direnv)] ++
    [(import ./cava)];
}
