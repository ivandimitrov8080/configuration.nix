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
      };
    };
  };
  extraConfigLuaPre = ''
    local function get_visual_select()
        local text = vim.fn.getregion(vim.fn.getpos('v'), vim.fn.getpos('.'), { type = vim.fn.mode() })
        return text[0] or text[1]
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
      key = "K";
      action = "<cmd>DocsViewToggle<cr>";
      options = {
        silent = true;
        desc = "LSP hover docs";
      };
    }
    {
      mode = "n";
      key = "<Tab>";
      action = "<cmd>BufferNext<cr>";
      options = {
        silent = true;
        desc = "Switch tabs forwards";
      };
    }
    {
      mode = "n";
      key = "<S-Tab>";
      action = "<cmd>BufferPrevious<cr>";
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
      action = "<cmd>BufferClose<cr>";
      options = {
        silent = true;
        desc = "Close current buffer";
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
      action.__raw = "require('telescope.builtin').current_buffer_fuzzy_find";
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
      action.__raw = "require('telescope.builtin').find_files";
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
      action.__raw = "require('telescope.builtin').live_grep";
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
  ];
  plugins = {
    auto-session.enable = true;
    barbar.enable = true;
    comment.enable = true;
    diffview.enable = true;
    gitsigns.enable = true;
    hop.enable = true;
    lualine.enable = true;
    nvim-autopairs.enable = true;
    todo-comments.enable = true;
    ts-autotag.enable = true;
    web-devicons.enable = true;
    which-key.enable = true;
    dap.enable = true;
    dap-ui.enable = true;
    dap-virtual-text.enable = true;
    friendly-snippets.enable = true;
    blink-emoji.enable = true;
    blink-copilot.enable = true;
    luasnip = {
      enable = true;
      fromLua = [ ];
      fromSnipmate = [
        { }
        { paths = "${pkgs.vimPlugins.vim-snippets}/snippets"; }
      ];
      fromVscode = [ ];
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
      extensions = {
        file-browser.enable = true;
        frecency.enable = true;
        ui-select.enable = true;
      };
    };
    treesitter = {
      enable = true;
      highlight.enable = true;
      indent.enable = true;
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
        snippets.preset = "luasnip";
        sources = {
          providers = {
            emoji = {
              module = "blink-emoji";
              name = "Emoji";
              score_offset = 15;
            };
            copilot = {
              async = true;
              module = "blink-copilot";
              name = "copilot";
              score_offset = 100;
              # Optional configurations
              opts = {
                max_completions = 3;
                max_attempts = 4;
                kind = "Copilot";
                debounce = 750;
                auto_refresh = {
                  backward = true;
                  forward = true;
                };
              };
            };
          };
          default = [
            "lsp"
            "path"
            "snippets"
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
    };
    onAttach = ''
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
        lspBufAction = "format";
      }
    ];
  };
  dependencies = {
    tree-sitter.enable = true;
  };
  extraPackages = with pkgs; [
    ghostscript_headless
    tectonic
    sqlite
    ripgrep
    inotify-tools
  ];
  extraConfigLua = ''
    require("docs-view").setup {
      position = "right",
      width = 80,
    }
  '';
  extraFiles = {
    "lua/docs-view.lua".text =
      # lua
      ''
        local M = {}
        local cfg = {}
        local buf, win, prev_win, autocmd
        local get_clients

        M.update = function()
          if not win or not vim.api.nvim_win_is_valid(win) then
            M.toggle()
          end

          local clients = get_clients()
          local gotHover = false
          for i = 1, #clients do
            if clients[i].supports_method("textDocument/hover") then
              gotHover = true
              break
            end
          end
          if not gotHover then
            return
          end

          local l, c = unpack(vim.api.nvim_win_get_cursor(0))
          vim.lsp.buf_request(0, "textDocument/hover", {
            textDocument = { uri = "file://" .. vim.api.nvim_buf_get_name(0) },
            position = { line = l - 1, character = c },
          }, function(err, result, ctx)
            if win and vim.api.nvim_win_is_valid(win) and result and result.contents then
              local md_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
              if vim.tbl_isempty(md_lines) then return end
              vim.api.nvim_buf_set_option(buf, "modifiable", true)
              vim.api.nvim_buf_set_lines(buf, 0, -1, true, md_lines)
              vim.api.nvim_buf_set_option(buf, "modifiable", false)
              vim.cmd("RenderMarkdown")
            end
          end)
        end

        M.toggle = function()
          if win and vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, false)
            if autocmd then
              vim.api.nvim_del_autocmd(autocmd)
            end
            buf, win, prev_win, autocmd = nil, nil, nil, nil
          else
            local height = cfg["height"]
            local width = cfg["width"]
            local update_mode = cfg["update_mode"]
            if update_mode ~= "manual" then
              update_mode = "auto"
            end

            prev_win = vim.api.nvim_get_current_win()

            if cfg.position == "bottom" then
              vim.api.nvim_command("bel new")
              width = vim.api.nvim_win_get_width(prev_win)
            elseif cfg.position == "top" then
              vim.api.nvim_command("top new")
              width = vim.api.nvim_win_get_height(prev_win)
            elseif cfg.position == "left" then
              vim.api.nvim_command("topleft vnew")
            else
              vim.api.nvim_command("botright vnew")
            end

            win = vim.api.nvim_get_current_win()
            buf = vim.api.nvim_get_current_buf()

            if cfg.position == "bottom" or cfg.position == "top" then
              vim.api.nvim_win_set_height(win, math.ceil(height))
            end
            vim.api.nvim_win_set_width(win, math.ceil(width))

            vim.api.nvim_buf_set_name(buf, "Docs View")
            vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
            vim.api.nvim_buf_set_option(buf, "swapfile", false)
            vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
            vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
            vim.api.nvim_buf_set_option(buf, "buflisted", false)

            vim.api.nvim_set_current_win(prev_win)

            if update_mode == "auto" then
              autocmd = vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                pattern = "*",
                callback = function()
                  if win and vim.api.nvim_win_is_valid(win) then
                    M.update()
                  else
                    vim.api.nvim_del_autocmd(autocmd)
                    buf, win, prev_win, autocmd = nil, nil, nil, nil
                  end
                end,
              })
            end
          end
        end

        M.setup = function(user_cfg)
          local default_cfg = {
            position = "right",
            height = 10,
            width = 60,
            update_mode = "auto",
          }

          cfg = vim.tbl_extend("force", default_cfg, user_cfg)

          if vim.fn.has("nvim-0.11.0") then
            get_clients = function()
              return vim.lsp.get_clients()
            end
          elseif vim.fn.has("nvim-0.8.0") then
            get_clients = function()
              return vim.lsp.get_active_clients()
            end
          else
            get_clients = function()
              return vim.lsp.buf_get_clients(0)
            end
          end

          vim.api.nvim_create_user_command("DocsViewToggle", M.toggle, { nargs = 0 })
          vim.api.nvim_create_user_command("DocsViewUpdate", M.update, { nargs = 0 })
          local group = vim.api.nvim_create_augroup("DocsViewRenderMarkdown", { clear = true })
          local function is_docs_view_buffer(b)
            return vim.api.nvim_buf_is_valid(b) and vim.api.nvim_buf_get_name(b) == "Docs View"
          end
          vim.api.nvim_create_autocmd("FileType", {
            group = group,
            pattern = "markdown",
            callback = function(ev)
              if is_docs_view_buffer(ev.buf) then
                pcall(vim.cmd, "RenderMarkdown enable")
              else
                pcall(vim.cmd, "RenderMarkdown disable")
              end
            end,
          })
        end
        return M
      '';
  };
}
