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
  };
}
