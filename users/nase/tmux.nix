{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    mouse = true;
    newSession = true;
    clock24 = true;
    shell = "${pkgs.fish}/usr/bin/fish";
    terminal = "xterm-256color";
  };
}
