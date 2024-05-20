{ ... }:
{
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
}
