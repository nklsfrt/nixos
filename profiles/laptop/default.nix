{ profiles, ... }:{
  imports = [ profiles.desktop ];

  powerManagement.powertop.enable = true;
  services.thermald.enable = true;
  boot.plymouth.enable = true;
}