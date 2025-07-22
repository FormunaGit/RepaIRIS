{ pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];

  # Install some packages
  environment.systemPackages = with pkgs; [
    neovim # Neovim.
    gparted # Partition editor.
    btop # System monitor.
    firefox-esr # Web browser.
    testdisk-qt # Data recovery tool.
    extundelete # Data recovery tool.
    # GParted tools
    btrfs-progs # The Better FS.
    bcachefs-tools # BTRFS but not BTRFS I guess?
    exfatprogs # Fat32 if it was good (and supported more than 4gb files)
    e2fsprogs # For all the Linux systems that aren't on BTRFS for some reason. (EXT2/3/4)
    f2fs-tools # Who uses this?
    dosfstools # For FAT16. Doesn't this come by default in NixOS?
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
