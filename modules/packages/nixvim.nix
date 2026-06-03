{
  pkgs,
  lib,
  ...
}:
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    globals.mapleader = " ";

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      wrap = false;
      ignorecase = true;
      smartcase = true;
      termguicolors = true;
      scrolloff = 8;
      signcolumn = "yes";
      cursorline = true;
      undofile = true;
      clipboard = "unnamedplus";
      foldmethod = "expr";
      foldexpr = "v:lua.vim.treesitter.foldexpr()";
      foldlevel = 99;
      conceallevel = 2;
    };

    colorschemes.ayu.enable = true;
    colorschemes.ayu.settings.mirage = false;

    plugins = {
      which-key.enable = true;

      telescope = {
        enable = true;
        extensions.fzf-native.enable = true;
      };

      nvim-tree = {
        enable = true;
        openOnSetup = false;
        autoClose = true;
      };

      lsp = {
        enable = true;
        inlayHints = true;
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
            extraOptions.offset_encoding = "utf-8";
          };
        };
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          mapping = {
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping.select_next_item()";
            "<S-Tab>" = "cmp.mapping.select_prev_item()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-e>" = "cmp.mapping.abort()";
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
        };
        snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
      };

      treesitter = {
        enable = true;
        nixGrammars = true;
        folding.enable = true;
        highlight.enable = true;
        indent.enable = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          c
          comment
          cpp
          css
          html
          javascript
          json
          lua
          markdown
          markdown_inline
          nix
          python
          svelte
          typescript
          vim
          vimdoc
        ];
      };

      treesitter-context = {
        enable = true;
        settings.max_lines = 3;
      };

      treesitter-textobjects.enable = true;

      rainbow-delimiters.enable = true;

      mini = {
        enable = true;
        mockDevIcons = true;
        modules = {
          icons = { };
          indentscope = {
            symbol = "│";
            options.try_as_border = true;
            draw.delay = 100;
          };
        };
      };

      conform-nvim = {
        enable = true;
        autoInstall.enable = true;
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
          };
        };
      };

      gitsigns.enable = true;

      comment.enable = true;

      render-markdown.enable = true;

      typst-preview = {
        enable = true;
        settings = { };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = ";";
        action = ":";
        options.desc = "CMD enter command mode";
      }
      {
        mode = "i";
        key = "jk";
        action = "<Esc>";
      }

      # Telescope (NvChad-style finder)
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<CR>";
        options.desc = "Find files";
      }
      {
        mode = "n";
        key = "<leader>fw";
        action = "<cmd>Telescope live_grep<CR>";
        options.desc = "Live grep";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>Telescope buffers<CR>";
        options.desc = "Find buffers";
      }
      {
        mode = "n";
        key = "<leader>fh";
        action = "<cmd>Telescope help_tags<CR>";
        options.desc = "Help tags";
      }
      {
        mode = "n";
        key = "<leader>fo";
        action = "<cmd>Telescope oldfiles<CR>";
        options.desc = "Old files";
      }
      {
        mode = "n";
        key = "<leader>fz";
        action = "<cmd>Telescope current_buffer_fuzzy_find<CR>";
        options.desc = "Fuzzy find in buffer";
      }

      # NvimTree
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>NvimTreeToggle<CR>";
        options.desc = "Toggle file explorer";
      }

      # Editor
      {
        mode = "n";
        key = "<leader>w";
        action = "<cmd>w<CR>";
        options.desc = "Save file";
      }
      {
        mode = [ "n" "i" "v" ];
        key = "<C-s>";
        action = "<cmd>w<CR>";
        options.desc = "Save file";
      }
      {
        mode = "n";
        key = "<leader>ch";
        action = "<cmd>nohlsearch<CR>";
        options.desc = "Clear highlights";
      }
      {
        mode = "n";
        key = "<leader>n";
        action = "<cmd>set nu!<CR>";
        options.desc = "Toggle line numbers";
      }
      {
        mode = "n";
        key = "<leader>rn";
        action = "<cmd>set rnu!<CR>";
        options.desc = "Toggle relative numbers";
      }

      # Format
      {
        mode = "n";
        key = "<leader>fm";
        action = "<cmd>lua require('conform').format()<CR>";
        options.desc = "Format file";
      }

      # Git
      {
        mode = "n";
        key = "<leader>gb";
        action = "<cmd>Gitsigns blame_line<CR>";
        options.desc = "Git blame line";
      }

      # LSP
      {
        mode = "n";
        key = "gd";
        action = "<cmd>lua vim.lsp.buf.definition()<CR>";
        options.desc = "Go to definition";
      }
      {
        mode = "n";
        key = "gr";
        action = "<cmd>lua vim.lsp.buf.references()<CR>";
        options.desc = "Go to references";
      }
      {
        mode = "n";
        key = "gi";
        action = "<cmd>lua vim.lsp.buf.implementation()<CR>";
        options.desc = "Go to implementation";
      }
      {
        mode = "n";
        key = "<leader>ra";
        action = "<cmd>lua vim.lsp.buf.rename()<CR>";
        options.desc = "Rename symbol";
      }
      {
        mode = "n";
        key = "<leader>ca";
        action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
        options.desc = "Code action";
      }
      {
        mode = "n";
        key = "K";
        action = "<cmd>lua vim.lsp.buf.hover()<CR>";
        options.desc = "Hover";
      }

      # Typst preview
      {
        mode = "n";
        key = "<leader>tp";
        action = "<cmd>TypstPreviewToggle<CR>";
        options.desc = "Typst Preview Toggle";
      }
      {
        mode = "n";
        key = "<leader>ts";
        action = "<cmd>TypstPreviewStop<CR>";
        options.desc = "Stop Typst Preview";
      }
    ];

    extraConfigLua = ''
      -- Disable unused built-in plugins (NvChad-like optimization)
      local disabled_builtins = {
        "2html_plugin", "tohtml", "getscript", "getscriptPlugin",
        "gzip", "logipat", "netrw", "netrwPlugin",
        "netrwSettings", "netrwFileHandlers", "matchit",
        "tar", "tarPlugin", "rrhelper", "spellfile_plugin",
        "vimball", "vimballPlugin", "zip", "zipPlugin",
        "tutor", "rplugin", "syntax", "synmenu",
        "optwin", "compiler", "bugreport", "ftplugin",
      }
      for _, plugin in ipairs(disabled_builtins) do
        vim.g["loaded_" .. plugin] = 1
      end

      -- Tree-sitter textobjects config
      require("nvim-treesitter.configs").setup({
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["ai"] = "@conditional.outer",
              ["ii"] = "@conditional.inner",
            },
          },
          move = {
            enable = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
          },
        },
      })
    '';
  };
}
