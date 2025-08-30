{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      # Plugin manager
      vim-plug

      # Soporte para C/C++, Nix, Python y Web Development
      nvim-lspconfig
      cmp-nvim-lsp
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp-vsnip
      vim-vsnip
      vim-cmake
      cmake-tools-nvim
      plenary-nvim
      vim-svelte
      emmet-vim
      vim-nix

      # Interfaz y tema
      lualine-nvim
      gruvbox
      bufferline-nvim
      nvim-tree-lua
      nvim-treesitter.withAllGrammars
      nvim-web-devicons

      # Herramientas de navegación y ayuda
      trouble-nvim
      telescope-nvim
      which-key-nvim
      symbols-outline-nvim
      indent-blankline-nvim
      gitsigns-nvim
      nvim-autopairs
    ];

    extraLuaConfig = ''
      -- --------------------
      -- Configuración Básica
      -- --------------------
      vim.o.syntax = "on"
      vim.o.number = true
      vim.o.relativenumber = true
      vim.o.tabstop = 4
      vim.o.shiftwidth = 4
      vim.o.expandtab = true
      vim.cmd("colorscheme gruvbox")

      -- Configuración del portapapeles
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

      -- --------------------
      -- Configuración de Plugins
      -- --------------------
      require('lualine').setup()
      require('nvim-tree').setup()
      require('trouble').setup()
      require('symbols-outline').setup()
      require('ibl').setup()
      require('gitsigns').setup()
      require('bufferline').setup()
      require('which-key').setup()
      require('nvim-autopairs').setup()
      require('telescope').setup()
      require('cmake-tools').setup({})

      -- --------------------
      -- LSP 
      -- --------------------
      local lspconfig = require('lspconfig')
      local cmp_nvim_lsp = require('cmp_nvim_lsp')

      -- La función on_attach se ha mejorado para manejar un cliente y un buffer específicos
      local on_attach = function(client, bufnr)
        -- Habilitar el formato en la escritura para pyright
        if client.name == 'pyright' then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = true })
            end,
          })
        end
        
        -- Mapeos de teclado para el LSP
        local opts = { noremap = true, silent = true }
        local buf_keymap = vim.api.nvim_buf_set_keymap
        buf_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        buf_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        buf_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        buf_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
      end

      -- servidores LSP
      local lsp_servers = {
        'clangd',
        'cmake',
        'nil_ls',
        'pyright',
        'ts_ls',
        'svelte',
        'tailwindcss',
        'html',
        'cssls'
      }

      for _, server in ipairs(lsp_servers) do
        local config = {
          on_attach = on_attach,
          capabilities = cmp_nvim_lsp.default_capabilities()
        }
        
        -- por servidor
        if server == 'cmake' then
          config.cmd = { "cmake-language-server" }
        end
        if server == 'nil_ls' then
          config.settings = { ['nil'] = { formatting = { command = { "alejandra" } } } }
        end
        if server == 'svelte' then
          config.settings = { svelte = { plugin = { html = { completions = { emmet = true } } } } }
        end
        
        pcall(function()
          lspconfig[server].setup(config)
        end)
      end

      -- --------------------
      -- Autocompletado (nvim-cmp)
      -- --------------------
      local cmp = require('cmp')
      local vsnip = vim.fn["vsnip#anonymous"]
      
      cmp.setup({
        snippet = {
          expand = function(args)
            vsnip(args.body)
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

      -- --------------------
      -- Atajos
      -- --------------------
      local map = vim.keymap.set
      local opts = { noremap = true, silent = true }

      map('n', '<leader>ff', '<cmd>Telescope find_files<CR>', opts)
      map('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', opts)
      map('n', '<leader>fb', '<cmd>Telescope buffers<CR>', opts)
      map('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', opts)

    '';
  };
}
