{ ... }:
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  home.persistence."/persist/home/nase".directories = [ ".local/share/direnv" ];
}
