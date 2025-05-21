{ ... }:
{
  programs.git = {
    enable = true;
    userEmail = "nklsfrt@noreply.codeberg.org";
    userName = "nklsfrt";
    signing = {
      key = "598E 323C 9994 2CD5 0E81 52F7 F392 5182 5187 BFED";
      signByDefault = true;

    };
    ignores = [
      ".envrc"
      ".direnv"
    ];
    aliases.fpush = "push --force-with-lease";
    extraConfig = {
      rerere = {
        enabled = true;
        autoUpdate = true;
      };
      branch.sort = "-committerdate";
    };
  };
}
