{ ... }: {
  programs.nixvim.plugins = {
    # Core Treesitter
    treesitter = {
      enable = true;
      settings = {
        ensure_installed = [
          "vim" "lua" "vimdoc" "html" "css" "nix" 
          "python" "javascript" "c" "cpp" "svelte" "markdown" "markdown_inline"
        ];
        highlight.enable = true;
        indent.enable = true;
      };
    };

    # Objetos de texto (Select/Move)
    treesitter-textobjects = {
      enable = true;
      settings = {
        select = {
          enable = true;
          lookahead = true;
          keymaps = {
            "af" = "@function.outer";
            "if" = "@function.inner";
            "ac" = "@class.outer";
            "ic" = "@class.inner";
            "ai" = "@conditional.outer";
            "ii" = "@conditional.inner";
          };
        };
        move = {
          enable = true;
          goto_next_start = {
            "]m" = "@function.outer";
            "]]" = "@class.outer";
          };
          goto_previous_start = {
            "[m" = "@function.outer";
            "[[" = "@class.outer";
          };
        };
      };
    };

    # Contexto pegajoso
    treesitter-context = {
      enable = true;
      settings.max_lines = 3;
    };

    # Paréntesis arcoíris
    rainbow-delimiters.enable = true;

    # Auto-etiquetado HTML/Svelte
    ts-autotag.enable = true;

    # Comentarios inteligentes
    ts-context-commentstring.enable = true;
    comment = {
      enable = true;
      settings.pre_hook = "require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()";
    };

    # Render Markdown
    render-markdown.enable = true;
  };
}
