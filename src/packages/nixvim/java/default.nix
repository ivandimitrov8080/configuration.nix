{
  main,
  lib,
  pkgs,
  ...
}:
let
  thisLib = import ../../../lib { inherit lib; };
  inherit (thisLib) endsWith findJars;
  vscode-java-debug = pkgs.callPackage ../../vscode-java-debug { };
  vscode-java-test = pkgs.callPackage ../../vscode-java-test { };
in
main.extend (
  let
    debugPlugins = findJars "${vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server";
    testPlugins = findJars "${vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test/server";
    jdtlsPlugins = builtins.filter (
      x:
      !(
        endsWith "com.microsoft.java.test.runner-jar-with-dependencies.jar" x
        || endsWith "jacocoagent.jar" x
      )
    ) (debugPlugins ++ testPlugins);
  in
  {
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
            "--jvm-arg=-javaagent:${pkgs.lombok.out}/share/java/lombok.jar"
          ];
          init_options = {
            bundles = jdtlsPlugins;
          };
        };
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>jtc";
        action.__raw = "require'jdtls'.test_class";
        options = {
          desc = "Jdtls - test class";
        };
      }
      {
        mode = "n";
        key = "<leader>jtm";
        action.__raw = "require'jdtls'.test_nearest_method";
        options = {
          desc = "Jdtls - test nearest method";
        };
      }
    ];
    extraPlugins = with pkgs.vimPlugins; [ sonarlint-nvim ];
    extraConfigLuaPost = ''
      require('sonarlint').setup({
        filetypes = { 'java' },
        server = { cmd = { '${pkgs.sonarlint-ls}/bin/sonarlint-ls', '-stdio' } }
      })
    '';
  }
)
