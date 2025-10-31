{
  vscode-utils,
  ...
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-java-debug";
    publisher = "vscjava";
    version = "0.58.2";
    hash = "sha256-5HstDeWLm298DHdgwfQHypbAZsXLncARqzNRaao+Jm8=";
  };
}
