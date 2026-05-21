{ config, pkgs, lib, inputs, ... }: {

  modules.profiles = {
    user = "neon";
    platform = "x86_64-linux";
  };

  # ── WSL Specifics ───────────────────────────────────────────────
  # Assuming you have a wsl.nix module in your modules/profiles/platform/
  wsl.enable = true;
  wsl.defaultUser = "neon"; # Matches your user profile

  # ── Networking ──────────────────────────────────────────────────
  networking.hostName = "wsl";
  # WSL handles networking; networkmanager often conflicts with WSL's bridge
  networking.networkmanager.enable = false;

  # ── Hardware ────────────────────────────────────────────────────
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # Remove boot, nvidia, and physical hardware modules here
  # WSL manages the kernel and microcode

  # ── Audio ───────────────────────────────────────────────────────
  # Kept for X11/PulseAudio forwarding if needed, but simplified
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # ── Services ────────────────────────────────────────────────────
  documentation.enable = false;
  services.openssh.enable = true;
  nixpkgs.config.allowUnfree = true;

  # ── System Packages ─────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    git
    wget
    gcc
    gnumake
    binutils
    # CLI-only for now; GUI apps like Discord can be run via Windows 
    # or added back once the base build is stable
  ];

  # ── Modular Config ─────────────────────────────────────────────
  modules = {
    xdg.enable = true;
    editors.neovim.enable = true;
    shell = {
      zsh.enable = true;
      tmux.enable = true;
      git.enable = true;
      gnupg.enable = true;
    };
    desktop = {
      # Disable the heavy sessions, keep fonts for terminal rendering
      fonts.enable = true;
    };
  };
}
