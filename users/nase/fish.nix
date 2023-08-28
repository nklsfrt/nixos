{pkgs, ...}: {
  programs.fish = {
    enable = true;
    functions = {
      fish_greeting.body = "";
      nsh = {
        description = "Short hand for entering a nix shell.";
        body = "command bash -c \"${pkgs.nix}/bin/nix shell nixpkgs#$argv[1]\"";
      };
      nrun = {
        description = "Short hand for running a nixpkgs application on demand.";
        body = "command bash -c \"${pkgs.nix}/bin/nix run nixpkgs#$argv[1]\"";
      };
      sshmux = {
        description = "Launches a remote tmux session or attaches to an existing one.";
        body = "ssh -t $argv systemd-run --scope --user tmux new -A -s ssh";
      };
      winreboot = {
        description = "Reboot the auto generated Windows boot entry.";
        body = "systemctl reboot --boot-loader-menu=1 --boot-loader-entry=auto-windows";
      };
    };
    plugins = [
      {
        name = "fzf.fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
    ];
  };
}
