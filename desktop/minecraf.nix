
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  services.minecraft-server = {
    enable = true;
    dataDir = "/mnt/olddrive/opt/minecrafTWO/";
    eula = true;
    openFirewall = true;
    package = pkgs.minecraftServers.vanilla;
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
