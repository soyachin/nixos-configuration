{config, pkgs, ... }:

{

  programs.neovim = {
    enable = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      # Plugin manager
      vim-plug

      # Soporte para C/C++ y autocompletado
      nvim-lspconfig
      cmp-nvim-lsp
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp-vsnip
      vim-vsnip

      # Interfaz bonita
      lualine-nvim
      gruvbox
      bufferline-nvim

      # Árbol de archivos
      nvim-tree-lua

      # Sintaxis mejorada
      nvim-treesitter.withAllGrammars

      # Iconos
      nvim-web-devicons

      # Herramientas de navegación y ayuda
      trouble-nvim
      telescope-nvim
      which-key-nvim
      symbols-outline-nvim

      # Visuales
      indent-blankline-nvim
      gitsigns-nvim

      nvim-autopairs
      vim-nix

      vim-cmake
      cmake-tools-nvim
      plenary-nvim
      telescope-nvim


    ];

    extraConfig = ''
      lua << EOF
      vim.o.syntax = "on"
      vim.o.number = true
      vim.o.relativenumber = true
      vim.o.tabstop = 4
      vim.o.shiftwidth = 4
      vim.o.expandtab = true
      vim.cmd("colorscheme gruvbox")

      -- Clipboard
      vim.g.clipboard = {
        name = 'wl-clipboard',
        copy = {
          ['+'] = 'wl-copy',
          ['*'] = 'wl-copy',
        },
        paste = {
          ['+'] = 'wl-paste',
          ['*'] = 'wl-paste',
        },
        cache_enabled = 1,
      }

      -- LSP para C/C++
      local lspconfig = require('lspconfig')
      lspconfig.clangd.setup {
        on_attach = function(client, bufnr)
          vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
              virtual_text = { prefix = "●" },
              signs = true,
              underline = true,
              update_in_insert = true,
            }
          )
        end
      }

      lspconfig.cmake.setup {
        cmd = {"cmake-language-server"}
      }

      -- LSP para Nix con nil
      lspconfig.nil_ls.setup {
        settings = {
          ['nil'] = {
            formatting = {
              command = { "alejandra" }
            }
          }
        }
      }

      lspconfig.pyright.setup {
        on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
          vim.lsp.buf.format({ async = true })
          end,
        })
        end 
      }

      -- Autocompletado con nvim-cmp
      local cmp = require'cmp'
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' }
        })
      })

      require('lualine').setup()
      require('nvim-tree').setup({
        renderer = {
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            }
          }
        }
      })

      require("cmake-tools").setup({})

      require("trouble").setup()
      require("symbols-outline").setup()
      require("ibl").setup()
      require("gitsigns").setup()
      require("bufferline").setup()
      require("which-key").setup()
      require("telescope").setup()
      require("nvim-autopairs").setup()
      
      require('telescope').setup{}

      local map = vim.keymap.set
      local opts = { noremap = true, silent = true }

      map('n', '<leader>ff', '<cmd>Telescope find_files<CR>', opts)
      map('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', opts)
      map('n', '<leader>fb', '<cmd>Telescope buffers<CR>', opts)
      map('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', opts)
    EOF
    '';
  };

}
