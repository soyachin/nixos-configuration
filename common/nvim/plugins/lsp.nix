{ pkgs, ... }: {
  programs.nixvim = {
    # Extra Plugins (Typst Preview)
    extraPlugins = with pkgs.vimPlugins; [
      (pkgs.vimUtils.buildVimPlugin {
        name = "typst-preview.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "chomosuke";
          repo = "typst-preview.nvim";
          rev = "v1.4.2"; 
          hash = "sha256-7jOKLZ7WKBdX1Ljbvuuki4zmuZ86l62jAN8q2kSThDs="; 
        };
      })
    ];

    extraConfigLua = ''
      require("typst-preview").setup({})
    '';

    plugins = {
      # LSP Config
      lsp = {
        enable = true;
        servers = {
          lua_ls.enable = true;
          nil_ls.enable = true;
          bashls.enable = true;
          clangd.enable = true;
          cssls.enable = true;
          html.enable = true;
          ts_ls.enable = true;
          jsonls.enable = true;
          tailwindcss.enable = true;
          eslint.enable = true;
          pyright.enable = true;
          yamlls.enable = true;
          cmake.enable = true;

          tinymist = {
            enable = true;
            settings = {
              exportPdf = "onType";
              outputPath = "$root/target/$dir/$name";
            };
          };
        };
      };

      # Autocompletado (CMP)
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-e>" = "cmp.mapping.close()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "buffer"; }
            { name = "path"; }
          ];
        };
      };

      # Formateo (Conform)
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            nix = [ "alejandra" "nixfmt" ];
            lua = [ "stylua" ];
            javascript = [ "prettier" ];
            typescript = [ "prettier" ];
            javascriptreact = [ "prettier" ];
            typescriptreact = [ "prettier" ];
            markdown = [ "prettier" ];
            c = [ "clang-format" ];
            cpp = [ "clang-format" ];
          };
          format_on_save = {
            timeout_ms = 500;
            lsp_fallback = true;
          };
        };
      };
    };
  };
}
