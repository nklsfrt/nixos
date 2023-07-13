{pkgs, ...}: {
  home.packages = with pkgs; [
    obsidian
  ];
  home.persistence."/persist/home/niklas".directories = [
    "Obsidian"
  ];
}
