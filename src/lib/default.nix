{ lib }:
let
  inherit (lib) mkOverride recurseIntoAttrs;
in
rec {
  endsWith =
    e: x:
    with builtins;
    let
      se = toString e;
      sx = toString x;
    in
    (stringLength sx >= stringLength se)
    && (substring ((stringLength sx) - (stringLength se)) (stringLength sx) sx) == se;
  findDefaults =
    root:
    with builtins;
    (filter (x: endsWith "default.nix" x) (lib.filesystem.listFilesRecursive root));
  specialOpts = [
    "package"
    "src"
    "theme"
    "dnscrypt-proxy"
    "kernelPackages"
    "defaultUserShell"
  ];
  excludeOpts = [
    "initExtra"
    "interactiveShellInit"
  ];
  mkDefaultAttrs =
    a:
    builtins.mapAttrs (
      n: v:
      if builtins.elem n excludeOpts then
        v
      else if builtins.isFunction v then
        v
      else if builtins.isList v then
        v
      else if builtins.isAttrs v then
        if builtins.elem n specialOpts then mkOverride 900 v else mkDefaultAttrs v
      else
        mkOverride 900 v
    ) a;
  wrapNixvim =
    nvim:
    recurseIntoAttrs {
      default = nvim;
      java = nvim.extend {
        extraConfigLuaPre = ''
          local function find_jdtls_plugins()
            local function split(inputstr, sep)
              if sep == nil then
                sep = "%s"
              end
              local t = {}
              for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
              end
              return t
            end
            local jdtls_plugins = { }
            local jdtls_plugins_path = os.getenv("JDTLS_PLUGINS")
            for _, s in ipairs(split(jdtls_plugins_path, ":")) do
              local java_test_bundles = vim.split(vim.fn.glob(s .. "/server/*.jar", 1), "\n")
              local excluded = {
                "com.microsoft.java.test.runner-jar-with-dependencies.jar",
                "jacocoagent.jar",
              }
              for _, java_test_jar in ipairs(java_test_bundles) do
                local fname = vim.fn.fnamemodify(java_test_jar, ":t")
                if not vim.tbl_contains(excluded, fname) then
                  table.insert(jdtls_plugins, java_test_jar)
                end
              end
            end
            return jdtls_plugins
          end
        '';
        plugins = {
          jdtls = {
            enable = true;
            settings = {
              cmd = [
                "jdtls"
                "-data"
                {
                  __raw = "os.getenv('HOME') .. '/.cache/jdtls/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')";
                }
                {
                  __raw = "os.getenv('LOMBOK_JAR') ~= nil and '--jvm-arg=-javaagent:' .. os.getenv('LOMBOK_JAR') or ''";
                }
              ];
              init_options = {
                bundles = {
                  __raw = "find_jdtls_plugins()";
                };
              };
            };
          };
          dap.enable = true;
          dap-ui.enable = true;
          dap-virtual-text.enable = true;
        };
      };
      c = nvim.extend {
        lsp.servers.ccls.enable = true;
      };
      haskell = nvim.extend {
        lsp.servers.hls.enable = true;
        plugins.haskell-scope-highlighting.enable = true;
      };
      scala = nvim.extend {
        lsp.servers.metals.enable = true;
      };
      rust = nvim.extend {
        plugins.rustaceanvim.enable = true;
      };
      web = nvim.extend {
        lsp.servers = {
          ts_ls.enable = true;
          svelte.enable = true;
          html.enable = true;
          cssls.enable = true;
          jsonls.enable = true;
          tailwindcss.enable = true;
        };
      };
      python = nvim.extend {
        lsp.servers.pylsp.enable = true;
      };
      lua = nvim.extend {
        lsp.servers.emmylua_ls.enable = true;
      };
    };
}
