{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    package = pkgs.vscodium;
    userSettings = {
      "editor" = {
        "fontSize" = 14;
        "fontFamily" = "Fira Code";
      };
      "git.autofetch" = true;
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
    };
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      matklad.rust-analyzer
      ms-azuretools.vscode-docker
      james-yu.latex-workshop
    ];
  };
  home.packages = with pkgs; [
    nil
  ];
}
