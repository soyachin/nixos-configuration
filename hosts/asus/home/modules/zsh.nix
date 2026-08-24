{ lib, ... }:
let
  tmuxEarlyInit = lib.mkOrder 500 ''
    if [[ -z "$TMUX" ]] && [[ $- == *i* ]]; then
       tmux new-session -A -s main
    fi
  '';
in
{
  programs.zsh = {
    enable = true;
    initContent = ''
      autoload -Uz colors && colors
      autoload -Uz vcs_info
      autoload -Uz add-zsh-hook
      setopt prompt_subst

      zstyle ':vcs_info:git:*' check-for-changes true
      zstyle ':vcs_info:git:*' unstagedstr '%F{red}●%f'
      zstyle ':vcs_info:git:*' stagedstr '%F{red}●%f'
      zstyle ':vcs_info:git:*' formats '%F{yellow}‹%b%f%u%c%F{yellow}› %f'
      zstyle ':vcs_info:git:*' actionformats '%F{yellow}‹%b|%a%f%u%c%F{yellow}› %f'

      function _bira_prompt() {
        vcs_info
        local return_code="%(?..%F{red}%? ↵%f)"
        RPROMPT="%B''${return_code}%b"
        if [[ -n "$IN_NIX_SHELL" ]]; then
          RPROMPT+=" %F{cyan}[nix-shell]%f"
        fi
      }
      add-zsh-hook precmd _bira_prompt

      PROMPT='╭─%B%(!.%F{red}.%F{green})%n@%m%f%b %B%F{blue}%~ %f%b''${vcs_info_msg_0_}
╰─%B%(!.#.$)%b '

      function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        command yazi "$@" --cwd-file="$tmp"
        IFS= read -r -d "" cwd < "$tmp"
        [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
        command rm -f -- "$tmp"
      }
    '';
    shellAliases = {
      maicra = "__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia prismlauncher";
      nrs = "sudo nixos-rebuild switch --flake ~/.config/nixos/#asus";
      nrt = "sudo nixos-rebuild test --flake ~/.config/nixos/#asus";
      kvm = "quickemu --vm kali-current.conf --width 1920 --height 1080";
      hkvm = "quickemu --vm kali-current.conf --display none";
      miniup = "sudo nixos-rebuild switch --flake ~/.config/nixos/#mini --sudo --ask-sudo-password";
      nvapp = "__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia ";
    };

    # initContent = tmuxEarlyInit;

    enableCompletion = true;
    completionInit = ''
      autoload -Uz compinit
      if [[ -n ''${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
        compinit
      else
        compinit -C
      fi
    '';
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.size = 10000;
  };
}
