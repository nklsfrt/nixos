{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    package = pkgs.vscodium;
    userSettings = {
      "[python]" = {
        "editor.defaultFormatter" = "ms-python.black-formatter";
        "editor.formatOnSave" = true;
      };
      "[rust]" = {
        "editor.formatOnSave" = true;
      };
      "editor.fontSize" = 14;
      "editor.fontFamily" = "Fira Code";
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
      ms-python.python
      ms-python.black-formatter
      nvarner.typst-lsp
    ];
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  home.packages = [ pkgs.nil ];
  home.persistence."/persist/home/niklas".directories = [
    ".config/VSCodium"
    ".local/share/direnv"
  ];
}
