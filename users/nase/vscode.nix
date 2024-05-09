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
      mkhl.direnv
      james-yu.latex-workshop
      jnoortheen.nix-ide
      matklad.rust-analyzer
      ms-azuretools.vscode-docker
      ms-python.python
    ];
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  home.packages = with pkgs; [
    nil
  ];
  home.persistence."/persist/home/niklas".directories = [
    ".config/VSCodium"
  ];
}
