_final: prev:
let
  inherit (prev) callPackage;
  hasNixvim = prev ? nixvim;
in
{
  screenshot = callPackage ./screenshot { };
  faenza = callPackage ./faenza { };
  volume = callPackage ./volume { };
  rtcqs = callPackage ./rtcqs { };
  ndlm = callPackage ./ndlm { };
  english-words = callPackage ./english-words { };
  askpass = callPackage ./askpass { };
  notmuch-ics-import = callPackage ./notmuch-ics-import { };
}
// (prev.lib.optionalAttrs hasNixvim {
  nixvim = callPackage ./nixvim { inherit (prev) nixvim; };
})
