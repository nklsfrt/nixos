{ ... }:
{
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "Fira Code:size=11";
      };
      colors.alpha = 0.8;
    };
  };
}
