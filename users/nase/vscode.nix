{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles = {
      default = {
        enableUpdateCheck = false;
        userSettings = {
          "git.autofetch" = true;
          "editor.fontSize" = 15;
          "editor.fontFamily" = "Adwaita Mono";
          "editor.fontLigatures" = true;
          "terminal.integrated.fontSize" = 16;
          "terminal.integrated.fontLigatures.enabled" = true;
        };
        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
          mkhl.direnv
          myriad-dreamin.tinymist
        ];
      };
      rust = {
        userSettings = {
          "[rust]" = {
            "editor.formatOnSave" = true;
          };
        };
        extensions = with pkgs.vscode-extensions; [
          mkhl.direnv
          rust-lang.rust-analyzer
        ];
      };
      python = {
        userSettings = {
          "[python]" = {
            "editor.defaultFormatter" = "ms-python.autopep8";
            "editor.formatOnSave" = true;
          };
        };
        extensions = with pkgs.vscode-extensions; [
          mkhl.direnv
          # ms-python.autopep8
          ms-python.python
        ];
      };
      typst = {
        userSettings = {
          "editor.fontSize" = 15;
          "editor.fontFamily" = "Adwaita Mono";
          "editor.fontLigatures" = true;
          "terminal.integrated.fontSize" = 16;
          "terminal.integrated.fontLigatures.enabled" = true;
          "[typst]" = {
            "editor.formatOnSave" = true;
            "tinymist.formatterMode" = "typstyle";
            "tinymist.lint.enabled" = true;
            "tinymist.lint.when" = "onType";
          };
        };
        extensions = with pkgs.vscode-extensions; [
          mkhl.direnv
          myriad-dreamin.tinymist
        ];
      };
    };
  };
  home.persistence."/persist".directories = [ ".config/VSCodium" ];
}
