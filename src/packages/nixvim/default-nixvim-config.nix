pkgs: {
  enableMan = false;
  viAlias = true;
  globals = {
    mapleader = " ";
    maplocalleader = " ";
  };
  opts = {
    tabstop = 4;
    shiftwidth = 2;
    textwidth = 120;
    scrolloff = 15;
    updatetime = 20;
    number = true;
    hlsearch = false;
    autoread = true;
    expandtab = true;
    spell = true;
    sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions";
    winborder = "rounded";
  };
  clipboard = {
    register = "unnamedplus";
    providers.wl-copy.enable = true;
  };
  colorschemes.catppuccin = {
    enable = true;
    settings = {
      flavour = "mocha";
      transparent_background = true;
      integrations = {
        gitsigns = true;
        treesitter = true;
        telescope.enabled = true;
        markdown = true;
        blink_cmp = true;
        render_markdown = true;
      };
    };
  };
  extraConfigLuaPre = ''
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local function get_visual_select()
        local text = vim.fn.getregion(vim.fn.getpos('v'), vim.fn.getpos('.'), { type = vim.fn.mode() })
        return text[0] or text[1]
    end
    local function get_last_search_history(title)
        local h = require("telescope").extensions.smart_history.smart_history()
        local p = { prompt_title = title, cwd = vim.loop.cwd() }
        h:_pre_get(nil, p)
        return h.content[#h.content] or ""
    end
    local function update_search_register(prompt_bufnr)
        vim.fn.setreg("/", action_state.get_current_line())
        actions.select_default(prompt_bufnr)
    end
  '';
  keymaps = [
    {
      mode = [
        "n"
        "v"
      ];
      key = "<PageUp>";
      action = "<Nop>";
      options = {
        silent = true;
        desc = "Don't map PageUp/PageDown.";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<PageDown>";
      action = "<Nop>";
      options = {
        silent = true;
        desc = "Don't map PageUp/PageDown.";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<Space>";
      action = "<Nop>";
      options = {
        silent = true;
        desc = "Don't map the leader key";
      };
    }
    {
      mode = "n";
      key = "<Tab>";
      action.__raw = "function() require('bufferline').cycle(1) end";
      options = {
        silent = true;
        desc = "Switch tabs forwards";
      };
    }
    {
      mode = "n";
      key = "<S-Tab>";
      action.__raw = "function() require('bufferline').cycle(-1) end";
      options = {
        silent = true;
        desc = "Switch tabs backwards";
      };
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<cmd>move +1<cr>";
      options = {
        silent = true;
        desc = "Move current line down by 1";
      };
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<cmd>move -2<cr>";
      options = {
        silent = true;
        desc = "Move current line up by 1";
      };
    }
    {
      mode = "n";
      key = "<C-s>";
      action = "<cmd>t.<cr>";
      options = {
        silent = true;
        desc = "Duplicate line";
      };
    }
    {
      mode = "n";
      key = "<leader>x";
      action = "<cmd>bd<cr>";
      options = {
        silent = true;
        desc = "Delete current buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>/";
      action.__raw = "require('Comment.api').toggle.linewise.current";
      options = {
        silent = true;
        desc = "Comment out the current line";
      };
    }
    {
      mode = "v";
      key = "<leader>/";
      action = "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>";
      options = {
        silent = true;
        desc = "Comment out the selection";
      };
    }
    {
      mode = "n";
      key = "/";
      action.__raw = ''
        function()
            local title = "Current Buffer Fuzzy"
            require("telescope.builtin").current_buffer_fuzzy_find({
              prompt_title = title,
              default_text = get_last_search_history(title),
            })
        end
      '';
      options.desc = "Search current buffer";
    }
    {
      mode = "v";
      key = "/";
      action.__raw = ''
        function()
            require('telescope.builtin').current_buffer_fuzzy_find({ default_text = get_visual_select() })
        end
      '';
      options.desc = "Current buffer fuzzy find";
    }
    {
      mode = "n";
      key = "<leader>ff";
      action.__raw = ''
        function()
            local title = "Find Files"
            require("telescope.builtin").find_files({
              prompt_title = title,
              default_text = get_last_search_history(title),
            })
        end
      '';
      options.desc = "Find files";
    }
    {
      mode = "v";
      key = "<leader>ff";
      action.__raw = ''
        function()
            require('telescope.builtin').find_files({ default_text = get_visual_select() })
        end
      '';
      options.desc = "Find files";
    }
    {
      mode = "n";
      key = "<leader>fw";
      action.__raw = ''
        function()
            local title = "Live Grep"
            require("telescope.builtin").live_grep({
              prompt_title = title,
              default_text = get_last_search_history(title),
            })
        end
      '';
      options.desc = "Find words";
    }
    {
      mode = "v";
      key = "<leader>fw";
      action.__raw = ''
        function()
            require('telescope.builtin').live_grep({ default_text = get_visual_select() })
        end
      '';
      options.desc = "Find words";
    }
    {
      mode = "n";
      key = "gr";
      action.__raw = "require('telescope.builtin').lsp_references";
      options.desc = "Go to references";
    }
    {
      mode = "n";
      key = "gi";
      action.__raw = "require('telescope.builtin').lsp_implementations";
      options.desc = "Go to implementations";
    }
    {
      mode = "n";
      key = "gd";
      action.__raw = "require('telescope.builtin').lsp_definitions";
      options.desc = "Go to definitions";
    }
    {
      mode = "n";
      key = "gt";
      action.__raw = "require('telescope.builtin').lsp_type_definitions";
      options.desc = "Go to type definitions";
    }
    {
      mode = "n";
      key = "gO";
      action.__raw = "require('telescope.builtin').lsp_document_symbols";
      options.desc = "Document symbols";
    }
    {
      mode = "n";
      key = "<leader>gO";
      action.__raw = "require('telescope.builtin').lsp_workspace_symbols";
      options.desc = "Workspace symbols";
    }
    {
      mode = "n";
      key = "<leader>e";
      action.__raw = "vim.diagnostic.open_float";
      options.desc = "Open diagnostics";
    }
    {
      mode = "n";
      key = "<leader>tt";
      action = "<cmd>TodoTelescope<cr>";
      options = {
        silent = true;
        desc = "Show Todo Telescope";
      };
    }
    {
      mode = "n";
      key = "<leader>tf";
      action = "<cmd>Telescope file_browser<cr>";
      options = {
        silent = true;
        desc = "Show Telescope file browser";
      };
    }
    {
      mode = "n";
      key = "<leader>h";
      action = "<cmd>HopChar1<cr>";
      options = {
        silent = true;
        desc = "Hop to character in buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>.";
      action.__raw = "function () Snacks.scratch() end";
      options = {
        desc = "Toggle scratch buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>S";
      action.__raw = "function () Snacks.scratch.select() end";
      options = {
        desc = "Select scratch buffer";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>gb";
      action = "<cmd>Gitsigns blame<cr>";
      options = {
        desc = "Git blame";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>gsh";
      action = "<cmd>Gitsigns stage_hunk<cr>";
      options = {
        desc = "Git stage hunk";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>grh";
      action = "<cmd>Gitsigns reset_hunk<cr>";
      options = {
        desc = "Git reset hunk";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>gsb";
      action = "<cmd>Gitsigns stage_buffer<cr>";
      options = {
        desc = "Git stage buffer";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>grb";
      action = "<cmd>Gitsigns reset_buffer<cr>";
      options = {
        desc = "Git reset buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>dn";
      action.__raw = "require'dap'.continue";
      options = {
        desc = "Debug - resume";
      };
    }
    {
      mode = "n";
      key = "<leader>do";
      action.__raw = "require'dap'.step_over";
      options = {
        desc = "Debug - step over";
      };
    }
    {
      mode = "n";
      key = "<leader>di";
      action.__raw = "require'dap'.step_into";
      options = {
        desc = "Debug - step into";
      };
    }
    {
      mode = "n";
      key = "<leader>dt";
      action.__raw = "require'dap'.toggle_breakpoint";
      options = {
        desc = "Debug - toggle breakpoint";
      };
    }
    {
      mode = "n";
      key = "<leader>drt";
      action.__raw = "require'dap'.repl.toggle";
      options = {
        desc = "Debug - repl - toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>ddt";
      action.__raw = "require'dapui'.toggle";
      options = {
        desc = "Debug - dapui - toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>de";
      action.__raw = "require'dapui'.eval";
      options = {
        desc = "Debug - dapui - eval";
      };
    }
    {
      mode = "v";
      key = "<leader>de";
      action.__raw = "function() require'dapui'.eval(get_visual_select()) end";
      options = {
        desc = "Debug - dapui - eval";
      };
    }
    {
      mode = "n";
      key = "<leader>of";
      action = "<cmd>e flake.nix<cr>";
      options = {
        desc = "Open project flake.nix";
      };
    }
  ];
  plugins = {
    auto-session.enable = true;
    bufferline.enable = true;
    blink-emoji.enable = true;
    blink-cmp-dictionary.enable = true;
    comment.enable = true;
    dap-ui.enable = true;
    dap-virtual-text.enable = true;
    dap.enable = true;
    diffview.enable = true;
    friendly-snippets.enable = true;
    gitsigns.enable = true;
    hop.enable = true;
    lualine.enable = true;
    mini-icons.enable = true;
    nvim-autopairs.enable = true;
    sqlite-lua.enable = true;
    todo-comments.enable = true;
    ts-autotag.enable = true;
    web-devicons.enable = true;
    which-key.enable = true;
    conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          nu = [ "nufmt" ];
        };
        formatters = {
          nufmt = {
            command = pkgs.lib.getExe pkgs.nufmt;
            args = [ "--stdin" ];
            stdin = true;
          };
        };
        default_format_opts.lsp_format = "fallback";
      };
    };
    luasnip = {
      enable = true;
      fromLua = [ { } ];
      fromSnipmate = [
        { }
        { paths = "${pkgs.vimPlugins.vim-snippets}/snippets"; }
        { paths = ./snippets; }
      ];
      fromVscode = [ { } ];
      filetypeExtend = {
        sh = [ "bash" ];
      };
    };
    snacks = {
      enable = true;
      settings = {
        input.enabled = true;
        bigfile.enabled = true;
        bufdelete.enabled = true;
        dim.enabled = true;
        image.enabled = true;
        notifier.enabled = true;
        quickfile.enabled = true;
        scratch.enabled = true;
        scroll.enabled = true;
        styles.enabled = true;
      };
    };
    telescope = {
      enable = true;
      enabledExtensions = [ "smart_history" ];
      extensions = {
        file-browser.enable = true;
        frecency.enable = true;
        ui-select.enable = true;
      };
      settings = {
        defaults = {
          history = {
            path.__raw = ''vim.fn.stdpath("data") .. "/telescope_history.sqlite3" '';
            limit = 100;
          };
          mappings = {
            i = {
              "<CR>".__raw = "function(prompt_bufnr) update_search_register(prompt_bufnr) end";
              "<C-k>".__raw =
                "function(prompt_bufnr) require('telescope.actions').move_selection_previous(prompt_bufnr) end";
              "<C-j>".__raw =
                "function(prompt_bufnr) require('telescope.actions').move_selection_next(prompt_bufnr) end";
            };
            n = {
              "<CR>".__raw = "function(prompt_bufnr) update_search_register(prompt_bufnr) end";
              "<C-k>".__raw =
                "function(prompt_bufnr) require('telescope.actions').cycle_history_prev(prompt_bufnr) end";
              "<C-j>".__raw =
                "function(prompt_bufnr) require('telescope.actions').cycle_history_next(prompt_bufnr) end";
            };
          };
        };
      };
    };
    treesitter = {
      enable = true;
      highlight.enable = true;
    };
    blink-cmp = {
      enable = true;
      settings = {
        keymap = {
          preset = "none";
          "<C-Space>" = {
            __raw = "{ function(cmp) cmp.show({ providers = { 'lsp' } }) end }";
          };
          "<C-c>" = {
            __raw = "{ function(cmp) cmp.show({ providers = { 'copilot' } }) end }";
          };
          "<CR>" = [
            "accept"
            "fallback"
          ];
          "<C-k>" = [
            "select_prev"
            "fallback"
          ];
          "<C-j>" = [
            "select_next"
            "fallback"
          ];
          "<Up>" = [
            "select_prev"
            "fallback"
          ];
          "<Down>" = [
            "select_next"
            "fallback"
          ];
        };
        completion = {
          accept = {
            auto_brackets = {
              enabled = true;
              semantic_token_resolution = {
                enabled = true;
              };
            };
          };
          documentation.auto_show = true;
          ghost_text.enabled = true;
          menu = {
            draw = {
              columns.__raw = ''
                {
                  { "label", "label_description", gap = 1 },
                  { "kind_icon", "kind" }
                }
              '';
            };
          };
        };
        signature.enabled = true;
        snippets.preset = "luasnip";
        sources = {
          providers = {
            lsp.score_offset = 100;
            snippets.score_offset = 100;
            path.score_offset = 100;
            dictionary.score_offset = 50;
            buffer.score_offset = 50;
            emoji.score_offset = 50;
            emoji = {
              module = "blink-emoji";
              name = "Emoji";
            };
            dictionary = {
              module = "blink-cmp-dictionary";
              name = "Dict";
              min_keyword_length = 4;
              opts = {
                dictionary_files = [ "${pkgs.english-words}/words_alpha.txt" ];
              };
            };
          };
          default = [
            "lsp"
            "snippets"
            "path"
            "dictionary"
            "buffer"
            "emoji"
          ];
        };
      };
    };
    render-markdown = {
      enable = true;
      settings.overrides = {
        buftype = {
          nofile = {
            enabled = true;
            render_modes = true;
          };
        };
      };
    };
    lsp.enable = true;
  };
  lsp = {
    servers = {
      nil_ls.enable = true;
      bashls.enable = true;
      nushell.enable = true;
    };
    onAttach =
      # lua
      ''
        if client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd("CursorHold", {
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.document_highlight()
                end,
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.clear_references()
                end,
            })
        end
        if client.server_capabilities.hoverProvider and vim.lsp.buf then
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.buf.with(vim.lsp.handlers.hover, {
              border = "rounded",
              max_width = 90,
              max_height = 25,
            })
        end
        if client.server_capabilities.signatureHelpProvider and vim.lsp.buf then
            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.buf.with(vim.lsp.handlers.signature_help, {
              border = "rounded",
              max_width = 90,
              max_height = 15,
            })
        end
      '';
    keymaps = [
      {
        key = "<leader>la";
        lspBufAction = "code_action";
      }
      {
        key = "<leader>lr";
        lspBufAction = "rename";
      }
      {
        key = "<leader>lf";
        action.__raw = "function() require('conform').format({async = true, lsp_fallback = true}) end";
      }
    ];
  };
  dependencies = {
    tree-sitter.enable = true;
  };
  extraPlugins = with pkgs.vimPlugins; [ telescope-smart-history-nvim ];
  extraPackages = with pkgs; [
    fzf
    ghostscript_headless
    inotify-tools
    ripgrep
    sqlite
    tectonic
    tree-sitter
    wordnet
  ];
  extraConfigLua = ''
    vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
    vim.api.nvim_set_hl(0, "FloatBorder", { link = "Comment" })
  '';
}
