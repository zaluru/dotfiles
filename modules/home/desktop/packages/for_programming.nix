{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Game dev
    godot_4
    #trenchbroom
  ];
}
