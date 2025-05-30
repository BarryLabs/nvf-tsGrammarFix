{
  lib,
  config,
  ...
}: let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) anything nullOr listOf submodule str;
  inherit (lib.nvim.types) mkPluginSetupOption;
  inherit (lib.nvim.config) mkBool;
in {
  options.vim.ui.noice = {
    enable = mkEnableOption "noice.nvim UI modification library";

    setupOpts = mkPluginSetupOption "noice.nvim" {
      lsp = {
        override = {
          "vim.lsp.util.convert_input_to_markdown_lines" =
            mkBool true "override the default lsp markdown formatter with Noice";

          "vim.lsp.util.stylize_markdown" =
            mkBool true "override the lsp markdown formatter with Noice";

          "cmp.entry.get_documentation" =
            mkBool config.vim.autocomplete.nvim-cmp.enable "override cmp documentation with Noice";
        };

        signature = {
          enabled = mkEnableOption "signature help";
        };
      };

      presets = {
        bottom_search = mkBool true "use a classic bottom cmdline for search";
        command_palette = mkBool true "position the cmdline and popupmenu together";
        long_message_to_split = mkBool true "long messages will be sent to a split";
        inc_rename = mkBool false "enables an input dialog for inc-rename.nvim";
        lsp_doc_border =
          mkBool config.vim.ui.borders.enable "add a border to hover docs and signature help";
      };

      # TODO: is it possible to write a submodule for this?
      format = {
        cmdline = mkOption {
          description = "formatting options for the cmdline";
          type = nullOr anything;
          default = {
            pattern = "^:";
            icon = "";
            lang = "vim";
          };
        };

        search_down = mkOption {
          description = "formatting options for search_down";
          type = nullOr anything;
          default = {
            kind = "search";
            pattern = "^/";
            icon = " ";
            lang = "regex";
          };
        };

        search_up = mkOption {
          description = "formatting options for search_up";
          type = nullOr anything;
          default = {
            kind = "search";
            pattern = "^%?";
            icon = " ";
            lang = "regex";
          };
        };

        filter = mkOption {
          description = "formatting options for filter";
          type = nullOr anything;
          default = {
            pattern = "^:%s*!";
            icon = "";
            lang = "bash";
          };
        };

        lua = mkOption {
          description = "formatting options for lua";
          type = nullOr anything;
          default = {
            pattern = "^:%s*lua%s+";
            icon = "";
            lang = "lua";
          };
        };

        help = mkOption {
          description = "formatting options for help";
          type = nullOr anything;
          default = {
            pattern = "^:%s*he?l?p?%s+";
            icon = "󰋖";
          };
        };
      };

      routes = mkOption {
        description = "How to route messages";
        type = listOf (submodule {
          options = {
            view = mkOption {
              description = "how this route is viewed";
              type = nullOr str;
              default = null;
            };

            filter = mkOption {
              description = "a filter for messages matching this route";
              type = anything;
            };

            opts = mkOption {
              description = "options for the view and the route";
              type = nullOr anything;
              default = null;
            };
          };
        });

        default = [
          {
            filter = {
              event = "msg_show";
              kind = "";
              find = "written";
            };
            opts = {skip = true;};
          }
        ];
        defaultText = "Hide written messages";
      };
    };
  };
}
