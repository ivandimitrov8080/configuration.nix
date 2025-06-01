{
  writers,
  lib,
  hosts ? [ ],
  flakePath,
  ...
}:
let
  inherit (builtins)
    map
    concatStringsSep
    readFile
    hasAttr
    ;
  inherit (lib) optionalString;
  flake = x: optionalString (hasAttr "ref" x) "--flake ${flakePath}#${x.ref}";
  profile = x: optionalString (hasAttr "profile" x) "--profile-name ${x.profile}";
  targetHost = x: optionalString (hasAttr "targetHost" x) "--target-host ${x.targetHost}";
  buildHost = x: optionalString (hasAttr "buildHost" x) "--build-host ${x.buildHost}";
  useRemoteSudo =
    x: optionalString (hasAttr "useRemoteSudo" x && x.useRemoteSudo) "--use-remote-sudo";
  command =
    x:
    # nu
    ''
      def --wrapped "main ${x.name}" [...rest] {
        ${x.command} ${x.subcommand} ${flake x} ${profile x} ${targetHost x} ${buildHost x} ${useRemoteSudo x} ...$rest
      }'';
in
writers.writeNuBin "xin"
  # nu
  ''
    let flake_path = "${flakePath}"
    ${concatStringsSep "\n" (map command hosts)}
    ${(readFile ./main.nu)}
  ''
