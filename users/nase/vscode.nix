{pkgs, ...}: {
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
      "python.linting.pylintEnabled" = true;
    };
    extensions = with pkgs.vscode-extensions; [
      arrterian.nix-env-selector
      james-yu.latex-workshop
      jnoortheen.nix-ide
      matklad.rust-analyzer
      ms-azuretools.vscode-docker
      ms-python.python
    ];
  };
  home.packages = with pkgs; [
    nil
  ];
  home.persistence."/persist/home/niklas".directories = [
    ".config/VSCodium"
  ];
}
