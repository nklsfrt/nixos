{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.nase = {
      imports = [./dconf.nix];

      home = {
        username = "nase";
        homeDirectory = "/home/niklas";
        stateVersion = "22.05";
        language = {
          base = "en_US.UTF-8";
          address = "de_DE.UTF-8";
          time = "de_DE.UTF-8";
          monetary = "de_DE.UTF-8";
          paper = "de_DE.UTF-8";
          numeric = "de_DE.UTF-8";
          measurement = "de_DE.UTF-8";
        };
        sessionVariables = {
          NIXOS_OZONE_WL = "1";
          EDITOR = "micro";
        };
      };

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

      programs.git = {
        enable = true;
        userEmail = "furtwaengler@posteo.de";
        userName = "Niklas Furtwängler";
        signing = {
          key = "2FDF 6458 1DBA 9A81 366F ED34 895D 6A61 1B8A F8AB";
          signByDefault = true;
        };
      };

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

      programs.firefox = {
        enable = true;
        profiles.niklas = {
          name = "niklas";
          path = "vlqejqkk.niklas";
        };
      };

      home.packages = with pkgs; [
        spot
        pavucontrol
        easyeffects
        tdesktop
        signal-desktop
        onlyoffice-bin
        nil
        evolution
        parsec-bin
      ];

      programs.fish = {
        enable = true;
        functions = {
          fish_greeting.body = "";
          sshmux = {
            description = "Launches a remote tmux session or attaches to an existing one.";
            body = "ssh -t $argv systemd-run --scope --user tmux new -A -s ssh";
          };
          winreboot = {
            description = "Reboot the auto generated Windows boot entry.";
            body = "systemctl reboot --boot-loader-menu=1 --boot-loader-entry=auto-windows";
          };
        };
      };

      programs.ssh = {
        enable = true;
        extraConfig = ''
          Host ashes
            HostName nklsfrt.de
          Host forest
            HostName 192.168.69.1
          Host driftwood
            HostName 192.168.69.5
          Host timber
            HostName 192.168.69.7
        '';
      };

      programs.gpg.enable = true;
      services.gpg-agent.enable = true;
    };
  };
}
