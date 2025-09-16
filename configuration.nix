{ config, pkgs, inputs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules
      inputs.home-manager.nixosModules.home-manager

    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc.options = "--delete-older-than 7d";

  nixpkgs.overlays = [
    (final: prev: {
      tailscale = prev.tailscale.overrideAttrs (oldAttrs: {
        doCheck = false;
      });
    })
  ];

  # -----------------------------------------------------------------------------------
  # I'll try niri for some time

  programs.niri.enable = true;
  # programs.waybar.enable = true;

  # Compatibility workaround for GNOME Apps

  programs.dconf.enable = true;

  # Wayland Fix for Niri and other TWMs

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  programs.light.enable = true; # brightness control

  security.pam.services.swaylock = {};

  # -----------------------------------------------------------------------------------
  
  # Configure console keymap
  console.keyMap = "la-latin1";

  programs.firefox  =  {
    enable  =  true ;
  };

  programs.zsh.enable = true;

  users.users.hojas = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "bluetooth" ];
  };

  environment.systemPackages = with pkgs; [
 # System Utilities
  unrar p7zip unzip yt-dlp wget scrcpy tmux zsh git tree neovim
  
  # Applications
  baobab 
  
  # Terminal Tools
  bat lsd ripgrep fd htop btop lldb
  gparted 
  
  # User Applications
  openvpn bottles
  obs-studio vesktop qbittorrent xournalpp easyeffects inkscape input-remapper
  krita ungoogled-chromium
  
  # Multimedia
  mpv vlc rmpc mpc-cli

  # Development
  nil alejandra
  tailwindcss-language-server
  svelte-language-server
  cmake
  cmake-language-server
  clang-tools
  gcc
  pyright
  vscode-langservers-extracted
  lua-language-server

  # Wayland Ecosystem
  xdg-desktop-portal-gtk
  xdg-desktop-portal-gnome
  swaybg
  swww
  rofi-wayland
  slurp
  swaylock
  mako 
  xwayland-satellite
  wl-clipboard
  kitty

  # Graphics
  aseprite

  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

  system.stateVersion = "24.11"; # Did you read the comment?

}
