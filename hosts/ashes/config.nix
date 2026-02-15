{
  config,
  inputs,
  abilities,
  ...
}:
{
  imports = [
    abilities.persistence
  ];

  boot.loader = {
    systemd-boot.enable = false;
  };

  networking = {
    hostId = "186284b2";
    firewall.interfaces."enp1s0" = {
      allowedTCPPorts = [
        80
        443
      ];
      allowedUDPPorts = [
        80
        443
      ];
    };
    nftables.enable = true;
    useNetworkd = true;
  };

  systemd.network = {
    enable = true;
    networks."20-enp1s0" = {
      matchConfig.Name = "enp1s0";
      address = [ "2a01:4f8:1c1b:bb96::1" ];
      gateway = [ "fe80::1" ];
      dns = [
        "2a01:4ff:ff00::add:1"
        "2a01:4ff:ff00::add:2"
      ];
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "nklsfrt@posteo.de";
    certs = {
      "talk.nklsfrt.de" = {
        group = "murmur";
        dnsProvider = "inwx";
        credentialFiles = {
          "INWX_USERNAME_FILE" = config.sops.secrets.inwx_username.path;
          "INWX_PASSWORD_FILE" = config.sops.secrets.inwx_password.path;
        };
      };
    };
  };

  services.murmur = {
    enable = true;
    bandwidth = 256000;
    openFirewall = true;
    registerName = "Reptiloiden in der EU e.V.";
    registerHostname = "talk.nklsfrt.de";
    sslCert = "/var/lib/acme/talk.nklsfrt.de/fullchain.pem";
    sslKey = "/var/lib/acme/talk.nklsfrt.de/key.pem";
    welcometext = "Hört, hört!";
    extraConfig = ''
      defaultchannel=4
      obfuscate=true
      rememberchannel=true
      rememberchannelduration=300
      sslCiphers=EECDH+AESGCM:EDH+aRSA+AESGCM
    '';
  };

  environment.persistence."/persist".directories = [
    "/var/lib/murmur"
    "/var/lib/acme"
  ];

  services.caddy =
    let
      webroot = inputs.website.outPath;
    in
    {
      enable = true;
      adapter = "caddyfile";
      configFile = builtins.toFile "Caddyfile" ''
        nklsfrt.de {
          header Strict-Transport-Security max-age=31536000
          encode zstd gzip
          root * ${webroot}
          file_server
        }

        www.nklsfrt.de {
          redir https://nklsfrt.de/
        }

        proof.nklsfrt.de {
          redir https://keyoxide.org/aspe:keyoxide.org:54UMIULBO36HX33OT5SO77ZF4A
        }

        talk.nklsfrt.de {
          header Content-Type text/html
          respond <<HTML
            <html>
              <head><title>Mumble Server</title></head>
              <body style="margin:0;display:flex;justify-content:center;align-items:center;height:100vh;font-family:sans-serif;">
                <div>
                  <h1>This is a Mumble voice server!</h1>
                  <p>An associated website doesn't exist.</p>
                  <p>Were you looking for <a href="mumble://talk.nklsfrt.de:64738/?title=Reptiloiden%20in%20der%20EU%20e.V.&url=talk.nklsfrt.de">this</a>?</p>
                </div>
              </body>
            </html>
            HTML 200
        }

        hellodarkness.de {
          respond hi!
        }

        www.hellodarkness.de {
          redir https://hellodarkness.de/
        }
      '';
    };

  sops.secrets = {
    inwx_username = { };
    inwx_password = { };
  };

}
