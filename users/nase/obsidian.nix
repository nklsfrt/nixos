{pkgs, ...}: {
  home.packages = [
    pkgs.obsidian
  ];
  home.persistence."/persist/home/niklas".directories = [
    "Obsidian"
  ];
}
