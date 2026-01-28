#{ config, pkgs, ... }:
#{ 
#  imports =
#    [ 
#        ./as-clifm.nix
#    ];

programs.mtr.enable = true;
programs.gnupg.agent = {
  enable = true;
  enableSSHSupport = true;
  pinentryPackage = pkgs.pinentry-curses; 
 };
programs.hyprland = {
  enable = true;
  package = hyprland.packages.${pkgs.system}.hyprland;
};
}
