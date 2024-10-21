{ ... }:
{
  programs.thunderbird = {
    enable = true;
    profiles.nase = {
      isDefault = true;
    };
  };
}
