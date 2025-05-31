{ ... }:
{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "html"
      "html-jinja"
      "nix"
      "typst"
    ];
    userSettings = {
      auto_update = false;
      telemetry.metrics = false;
      buffer_font_family = "Adwaita Mono";
      buffer_font_size = 16;
      ui_font_family = "Adwaita Sans";
      ui_font_size = 17;
      languages = {
        Nix = {
          language_servers = [
            "nil"
            "!nixd"
          ];
        };
        Typst = {
          format_on_save = "language_server";
          language_servers = [ "tinymist" ];
        };
      };
      lsp = {
        nil = {
          initialization_options = {
            formatting = {
              command = [ "nixfmt" ];
            };
            nix = {
              flake = {
                autoArchive = true;
              };
            };
          };
        };
        tinymist = {
          settings = {
            exportPdf = "onSave";
            lint = {
              enabled = true;
              when = "onType";
            };
            formatterMode = "typstyle";
          };
        };
      };
    };
  };
}
