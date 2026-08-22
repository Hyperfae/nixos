
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  services.minecraft-server = {
    enable = false;
    dataDir = "/mnt/olddrive/opt/minecrafTWO/";
    eula = true;
    openFirewall = true;
    package = pkgs.minecraft-server.override {
      url = "https://piston-data.mojang.com/v1/objects/9580afcd37c63cb01e81d5d9f836f21b4d21c540/server.jar";
      sha1 = "832j2k8vy8vginfmh4gb0g666z6sz04m";
      jre_headless = pkgs.jdk25_headless;
    };
  };
  users.users.lizzie.extraGroups = [ "minecraft" ];
  users.users.minecraft = {
    extraGroups = ["systemd-journal"];
    packages = with pkgs; [
      tmux
    ];
    shell = pkgs.zsh;
    homeMode = "750";
  };
}
