{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    version.enableNixpkgsReleaseCheck = false;
    nixpkgs.source = inputs.nixpkgs;

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

      bufferline.enable = true;

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
          turtle_ls = {
            enable = true;
            cmd = [
              (lib.getExe (pkgs.callPackage ../../hosts/asus/modules/packages/custom/turtle-language-server { }))
              "--stdio"
            ];
          };
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
        grammarPackages = config.programs.nixvim.plugins.treesitter.package.allGrammars ++ [
          pkgs.tree-sitter-grammars.tree-sitter-turtle
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
            nix = [
              "alejandra"
              "nixfmt"
            ];
            lua = [ "stylua" ];
            javascript = [ "prettier" ];
            typescript = [ "prettier" ];
            javascriptreact = [ "prettier" ];
            typescriptreact = [ "prettier" ];
            markdown = [ "prettier" ];
            c = [ "clang-format" ];
            cpp = [ "clang-format" ];
            turtle = [ "prttl" ];
          };

          formatters.prttl = {
            command = "prttl";
            args = [ "$FILENAME" ];
            stdin = false;
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
        mode = [
          "n"
          "i"
          "v"
        ];
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

      # Buffer navigation
      {
        mode = "n";
        key = "<Tab>";
        action = "<cmd>bnext<CR>";
        options.desc = "Next buffer";
      }
      {
        mode = "n";
        key = "<S-Tab>";
        action = "<cmd>bprevious<CR>";
        options.desc = "Previous buffer";
      }
      {
        mode = "n";
        key = "<leader>x";
        action = "<cmd>bdelete<CR>";
        options.desc = "Close buffer";
      }

      # System clipboard (Wayland)
      {
        mode = "v";
        key = "<leader>y";
        action = "\"+y";
        options.desc = "Yank to system clipboard";
      }
      {
        mode = "n";
        key = "<leader>Y";
        action = "\"+Y";
        options.desc = "Yank line to system clipboard";
      }
      {
        mode = "n";
        key = "<leader>p";
        action = "\"+p";
        options.desc = "Paste from system clipboard";
      }
      {
        mode = "v";
        key = "<leader>p";
        action = "\"+p";
        options.desc = "Paste from system clipboard";
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

      # Diagnostics (NvChad-style)
      {
        mode = "n";
        key = "]d";
        action.__raw = "function() vim.diagnostic.goto_next({ float = { border = 'rounded' } }) end";
        options.desc = "Next diagnostic";
      }
      {
        mode = "n";
        key = "[d";
        action.__raw = "function() vim.diagnostic.goto_prev({ float = { border = 'rounded' } }) end";
        options.desc = "Previous diagnostic";
      }
      {
        mode = "n";
        key = "<leader>do";
        action.__raw = "function() vim.diagnostic.open_float({ border = 'rounded' }) end";
        options.desc = "Open diagnostic float";
      }
      {
        mode = "n";
        key = "<leader>dl";
        action = "<cmd>Telescope diagnostics<CR>";
        options.desc = "List diagnostics";
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

    autoCmd = [
      {
        event = [
          "BufRead"
          "BufNewFile"
        ];
        pattern = [ "*.ttl" ];
        command = "set filetype=turtle";
      }
    ];

    extraPlugins = [
      (pkgs.stdenv.mkDerivation {
        name = "sparql-completer-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "aminem0";
          repo = "sparql-completer.nvim";
          rev = "5db31c2208197fe591e0e58fad79d52c1713f086";
          sha256 = "145zfvbdy6dsi865yc1rcrvw8l9zi96nvdlydy18nrccb8zf340d";
        };
        installPhase = ''
          mkdir -p $out
          cp -r . $out/
        '';
      })
    ];

    extraPackages = [
      (pkgs.callPackage ../../hosts/asus/modules/packages/custom/turtle-language-server { })
      (pkgs.callPackage ../../hosts/asus/modules/packages/custom/prttl { })
    ];

    extraFiles."queries/turtle/highlights.scm".text = builtins.readFile ./turtle-highlights.scm;

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

            require('sco').setup({
        -- solo los vocabularios relevantes para trama
        sources = { "owl", "rdf", "rdfs", "xsd", "skos", "dcterms", "vann", "void" },
        enable_keymaps = false,   -- evita conflicto con <leader>ra (rename)
        enable_autocmds = false,  -- los autocmds son para .sparql/.rq de todas formas
      })

      -- activar sparql_completer para turtle manteniendo tus otras sources
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'turtle',
        callback = function()
          require('cmp').setup.buffer({
            sources = {
              { name = 'sparql_completer', priority = 100 },
              { name = 'nvim_lsp' },
              { name = 'luasnip' },
              { name = 'buffer' },
            }
          })
        end,
      })

            -- turtle_ls configurado vía nixvim LSP module
    '';
  };
}
