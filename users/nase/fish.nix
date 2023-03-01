{...}: {
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
}
