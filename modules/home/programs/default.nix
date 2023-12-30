{ ... }: 

{
  imports = 
    [(import ./kitty)] ++
    [(import ./alacritty)] ++
    [(import ./neofetch)] ++
    [(import ./astronvim)] ++
    [(import ./zellij)] ++
    [(import ./fish)] ++
    [(import ./nushell)] ++
    [(import ./starship)] ++
    [(import ./direnv)] ++
    [(import ./imv)] ++
    [(import ./nyxt)] ++
    [(import ./zathura)] ++
    [(import ./bottom)] ++
    [(import ./eza)] ++
    [(import ./cava)] ++
    [(import ./mpd)] ++
    [(import ./ncmpcpp)] ++
    [(import ./ssh)];
}
