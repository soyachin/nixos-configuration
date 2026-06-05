{ config, pkgs, ... }:

{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "gruvbox_dark_v2";
      theme_background = false;
      vim_keys = true;
    };
  };

  xdg.configFile."btop/themes/gruvbox_dark_v2.theme".text = ''
    # Bashtop gruvbox (https://github.com/morhetz/gruvbox) theme

    theme[main_bg]="#282828"
    theme[main_fg]="#EBDBB2"
    theme[title]="#EBDBB2"
    theme[hi_fg]="#CC241D"
    theme[selected_bg]="#32302F"
    theme[selected_fg]="#D3869B"
    theme[inactive_fg]="#3C3836"
    theme[graph_text]="#A89984"
    theme[proc_misc]="#98971A"
    theme[cpu_box]="#A89984"
    theme[mem_box]="#A89984"
    theme[net_box]="#A89984"
    theme[proc_box]="#A89984"
    theme[div_line]="#A89984"
    theme[temp_start]="#98971A"
    theme[temp_mid]=""
    theme[temp_end]="#CC241D"
    theme[cpu_start]="#8EC07C"
    theme[cpu_mid]="#D79921"
    theme[cpu_end]="#CC241D"
    theme[free_start]="#CC241D"
    theme[free_mid]="#D79921"
    theme[free_end]="#8EC07C"
    theme[cached_start]="#458588"
    theme[cached_mid]="#83A598"
    theme[cached_end]="#8EC07C"
    theme[available_start]="#CC241D"
    theme[available_mid]="#D65D0E"
    theme[available_end]="#FABD2F"
    theme[used_start]="#8EC07C"
    theme[used_mid]="#D65D0E"
    theme[used_end]="#CC241D"
    theme[download_start]="#98971A"
    theme[download_mid]="#689d6A"
    theme[download_end]="#B8BB26"
    theme[upload_start]="#CC241D"
    theme[upload_mid]="#D65d0E"
    theme[upload_end]="#FABF2F"
    theme[process_start]="#8EC07C"
    theme[process_mid]="#FE8019"
    theme[process_end]="#CC241D"
  '';
}
