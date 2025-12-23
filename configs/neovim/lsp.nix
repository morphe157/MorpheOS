{
  lsp.inlayHints.enable = true;
  plugins.none-ls = {
    enable = true;
    sources.diagnostics.ktlint.enable = true;
    sources.formatting.ktlint.enable = true;
  };
  plugins.conform-nvim = {
    enable = true;
    autoInstall.enable = true;
    settings = {
      default_format_opts.lsp_format = "fallback";
      formatters = { };
      formatters_by_ft = {
        kotlin = [ "ktlint" ];
				formatters = {
					ktlint = {
						command = "ktlint";
					};
				};
      };
      log_level = "error";
      notify_no_formatters = true;
      notify_on_error = true;
    };
  };
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
        # cmd = [
        #   "kotlin-lsp"
        #   "--stdio"
        # ];
        enable = true;
        # settings = {
        # "kotlin.formatting.ktfmt.indent" = 2;
        # "formatting.ktfmt.indent" = 2;
        # };
      };
      java_language_server.enable = true;
      html.enable = true;
      nixd = {
        enable = true;
      };
    };
  };
}
