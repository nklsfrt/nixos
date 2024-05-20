{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    package = pkgs.vscodium;
    userSettings = {
      "[rust]" = {
        "editor.formatOnSave" = true;
      };
      "editor.fontSize" = 14;
      "editor.fontFamily" = "Fira Code";
      "git.autofetch" = true;
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "terminal.integrated.allowWorkspaceConfiguration" = true;
      "terminal.integrated.allowAddWorkspaceFolderCommand" = true;
    };
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      matklad.rust-analyzer
      mkhl.direnv
      ms-python.python
      nvarner.typst-lsp
    ];
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  home.packages = with pkgs; [ nil ];
  home.persistence."/persist/home/niklas".directories = [
    ".config/VSCodium"
    ".local/share/direnv"
  ];
}
