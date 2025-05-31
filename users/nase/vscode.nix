{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default = {
      enableUpdateCheck = false;
      userSettings = {
        "[python]" = {
          "editor.defaultFormatter" = "ms-python.black-formatter";
          "editor.formatOnSave" = true;
        };
        "[rust]" = {
          "editor.formatOnSave" = true;
        };
        "editor.fontSize" = 14;
        "editor.fontFamily" = "FiraCode Nerd Font";
        "editor.fontLigatures" = "true";
        "flake8.args" = [ "--max-line-length=180" ];
        "git.autofetch" = true;
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
      };
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        rust-lang.rust-analyzer
        mkhl.direnv
        myriad-dreamin.tinymist
      ];
    };
  };
  home.persistence."/persist/home/nase".directories = [ ".config/VSCodium" ];
}
