{pkgs, ...}: {
  services.printing = {
    enable = true;
    drivers = with pkgs; [gutenprint];
  };

  hardware.sane = {
    enable = true;
    openFirewall = true;
    extraBackends = with pkgs; [sane-airscan];
  };
  environment.systemPackages = [pkgs.simple-scan];
}
