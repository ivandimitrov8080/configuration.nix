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
  };
  colorschemes.catppuccin = {
    enable = true;
    settings = {
      flavour = "mocha";
      transparent_background = true;
      integrations = {
        cmp = true;
        gitsigns = true;
        treesitter = true;
        telescope = {
          enabled = true;
        };
        markdown = true;
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
    cmp-nvim-lsp.enable = true;
    cmp-spell.enable = true;
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
      settings = {
        highlight = {
          enable = true;
          disable = [ "text" ];
        };
        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<C-a>";
            node_incremental = "<C-a>";
            scope_incremental = "<C-s>";
            node_decremental = "<C-d>";
          };
        };
      };
    };
    copilot-lua.enable = true;
    cmp = {
      enable = true;
      settings = {
        snippet.expand = {
          __raw = "function(args) vim.snippet.expand(args.body) end";
        };
        mapping = {
          __raw = ''
            cmp.mapping.preset.insert({
              ['<C-d>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }),
              ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'});
              ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'});
            })
          '';
        };
        sources = [
          { name = "buffer"; }
          { name = "treesitter"; }
          { name = "copilot"; }
          { name = "emoji"; }
          { name = "git"; }
          { name = "luasnip"; }
          { name = "nerdfont"; }
          { name = "nvim_lsp"; }
          { name = "nvim_lsp_document_symbol"; }
          { name = "nvim_lsp_signature_help"; }
          { name = "path"; }
        ];
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
        key = "K";
        lspBufAction = "hover";
      }
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
}
