_final: prev:
let
  inherit (prev) callPackage;
  hasNixvim = prev ? nixvim;
in
{
  screenshot = callPackage ./screenshot { };
  metaThemes = callPackage ./themes { };
  faenza = callPackage ./faenza { };
  volume = callPackage ./volume { };
  rtcqs = callPackage ./rtcqs { };
  walogram = callPackage ./walogram { };
  ndlm = callPackage ./ndlm { };
  english-words = callPackage ./english-words { };
}
// (prev.lib.optionalAttrs hasNixvim {
  nixvim = callPackage ./nixvim { nixvim = prev.nixvim; };
})
