{ ... }:
{
networking.useNetworkd = true;

systemd.network =
  let
    wan-nic = "wan";
    lan1 = "lan1";
    lan2 = "lan2";
    lan3 = "lan3";
    lan-bridge = "bridge1";
  in
  {
    enable = true;
    links = {
      "10-${wan-nic}" = {
        matchConfig.PermanentMACAddress = "7c:2b:e1:13:88:9f";
        linkConfig.Name = "${wan-nic}";
      };
      "10-${lan1}" = {
        matchConfig.PermanentMACAddress = "7c:2b:e1:13:88:a0";
        linkConfig.Name = lan1;
      };
      "10-${lan2}" = {
        matchConfig.PermanentMACAddress = "7c:2b:e1:13:88:a1";
        linkConfig.Name = lan2;
      };
      "10-${lan3}" = {
        matchConfig.PermanentMACAddress = "7c:2b:e1:13:88:a2";
        linkConfig.Name = lan3;
      };
    };
    netdevs = {
      "20-${lan-bridge}" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "${lan-bridge}";
        };
      };
    };
    networks = {
      "30-${wan-nic}" = {
        matchConfig.Name = "${wan-nic}";
        networkConfig = {
          DHCP = "yes";
          IPForward = true;
        };
      };
      "30-${lan1}" = {
        matchConfig.Name = lan1;
        networkConfig.Bridge = lan-bridge;
        linkConfig.RequiredForOnline = "no-carrier";
      };
      "30-${lan2}" = {
        matchConfig.Name = lan2;
        networkConfig.Bridge = lan-bridge;
        linkConfig.RequiredForOnline = "no-carrier";
      };
      "30-${lan3}" = {
        matchConfig.Name = lan3;
        networkConfig.Bridge = lan-bridge;
        linkConfig.RequiredForOnline = "no-carrier";
      };
      "40-${lan-bridge}" = {
        matchConfig.Name = "${lan-bridge}";
        networkConfig.IPForward = true;
        linkConfig.RequiredForOnline = "no-carrier";
      };
    };
  };
}
