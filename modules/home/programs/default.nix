{ ... }: 

{
  imports = 
    [(import ./kitty)] ++
    [(import ./alacritty)] ++
    [(import ./neofetch)] ++
    #[(import ./neovim)] ++
    [(import ./zellij)] ++
    [(import ./fish)] ++
    [(import ./starship)] ++
    [(import ./direnv)] ++
    [(import ./imv)] ++
    [(import ./nyxt)] ++
    [(import ./zathura)] ++
    [(import ./cava)];
}
