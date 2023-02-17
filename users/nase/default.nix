{ inputs, ... }:{
  imports = with inputs; [ home-manager.nixosModules.home-manager ];

  users.users.nase.description = "Niklas Furtwängler";
  
  home-manager.users.nase = import ./home.nix;
}