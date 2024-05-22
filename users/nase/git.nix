{ ... }:
{
  programs.git = {
    enable = true;
    userEmail = "furtwaengler@posteo.de";
    userName = "Niklas Furtwängler";
    signing = {
      key = "2FDF 6458 1DBA 9A81 366F ED34 895D 6A61 1B8A F8AB";
      signByDefault = true;
    };
    ignores = [
      ".envrc"
      ".direnv"
    ];
  };
}
