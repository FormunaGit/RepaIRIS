{ pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];

  # Install some packages
  environment.systemPackages = with pkgs; [
    neovim
    gparted
    btop
    firefox-esr
    testdisk-qt
    extundelete
  ];

  # Enable PulseAudio
  nixpkgs.config.pulseaudio = true;

  # Enable Xfce desktop environment
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
  };
  services.displayManager.defaultSession = "xfce";

  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
}
