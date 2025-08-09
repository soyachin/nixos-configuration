{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      # Plugin manager
      vim-plug

      # LSP y autocompletado
      nvim-lspconfig
      cmp-nvim-lsp
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp-vsnip
      vim-vsnip

      # Web Development
      vim-svelte
      emmet-vim

      # Interfaz
      lualine-nvim
      gruvbox
      nvim-tree-lua
      nvim-treesitter.withAllGrammars
      nvim-web-devicons

      # Herramientas
      telescope-nvim
      trouble-nvim
      nvim-autopairs
      vim-nix
    ];

    extraLuaConfig = ''
      -- Configuración básica
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.tabstop = 4
      vim.opt.shiftwidth = 4
      vim.cmd("colorscheme gruvbox")

      -- Configuración LSP condicional (actualizada)
      local lsp_servers = {
        'ts_ls',         -- Mantenido por compatibilidad (usará ts_ls internamente)
        'svelte',
        'tailwindcss',
        'html',
        'cssls',
        'nil_ls',
        'pyright',
        'clangd'
      }

      local lspconfig = require('lspconfig')
      for _, server in ipairs(lsp_servers) do
        local config = {
          capabilities = require('cmp_nvim_lsp').default_capabilities()
        }
        
        
        if server == 'ts_ls' then
          config.cmd = { "typescript-language-server", "--stdio" }
          config.filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }
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

      -- Configuración de autocompletado
      require('cmp').setup({
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' }
        }
      })
    '';
  };

}