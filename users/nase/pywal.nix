{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [ pywal ];
  home.activation.pywal = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.pywal}/bin/wal -i ~/.background-image
  '';
  programs.fish.interactiveShellInit = ''
    cat ~/.cache/wal/sequences
  '';
  home.persistence."/persist/home/nase".files = [ ".cache/wal/sequences" ];
}
