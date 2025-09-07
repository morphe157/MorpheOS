{
  plugins.lsp = {
    enable = true;
    servers = {
      ruff.enable = true;
      pyright.enable = true;
      lua_ls = {
        enable = true;
      };
      nil_ls.enable = true;
      kotlin_language_server = {
        enable = true;
        settings = {
          "kotlin.formatting.ktfmt.indent" = 2;
          "formatting.ktfmt.indent" = 2;
        };
      };
      java_language_server.enable = true;
      html.enable = true;
      nixd = {
        enable = true;
      };
    };
    luaConfig.post = ''
      require'lspconfig'.lua_ls.setup {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath('config') and (vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc')) then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              -- Tell the language server which version of Lua you're using
              -- (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME
                -- Depending on the usage, you might want to add additional paths here.
                -- "''${3 rd}/luv/library"
                -- "''${3 rd}/busted/library",
              }
              -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
              -- library = vim.api.nvim_get_runtime_file("", true)
            }
          })
        end,
        settings = {
          Lua = {}
        }
      }
    '';
  };
}
