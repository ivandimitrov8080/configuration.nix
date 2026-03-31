_final: prev:
let
  inherit (prev) callPackage;
  hasNixvim = prev ? nixvim;
in
{
  screenshot = callPackage ./screenshot { };
  themes = callPackage ./themes { };
  faenza = callPackage ./faenza { };
  volume = callPackage ./volume { };
  rtcqs = callPackage ./rtcqs { };
  walogram = callPackage ./walogram { };
  ndlm = callPackage ./ndlm { };
}
// (prev.lib.optionalAttrs hasNixvim {
  nixvim = callPackage ./nixvim { nixvim = prev.nixvim; };
})
