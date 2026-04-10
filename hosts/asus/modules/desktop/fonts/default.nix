{
  config,
  pkgs,
  ...
}: {
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    aileron
    fragment-mono
    comic-mono
    work-sans
    hubot-sans
    eurofurence
    dosis
    manrope
    montserrat
    helvetica-neue-lt-std
    nerd-fonts.fira-code
    nerd-fonts.ubuntu
    nerd-fonts.hack
    nerd-fonts.comic-shanns-mono

    carlito
    dejavu_fonts
    ipafont
    kochi-substitute
    source-code-pro
    ttf_bitstream_vera
  ];
}
