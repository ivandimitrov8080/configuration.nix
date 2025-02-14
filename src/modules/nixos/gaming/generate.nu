#!/usr/bin/env nu

def gen_nix_rule [ip] {
$'  {
    To = "($ip)/32";
    Priority = 5;
  }'
}

let rules = [
    "https://api.steampowered.com/ISteamApps/GetSDRConfig/v1/?appid=730",
    "https://api.steampowered.com/ISteamApps/GetSDRConfig/v1/?appid=570"
]
| each { |u| http get $u | get pops | transpose server info | each { |srv| $srv.info.relays?.ipv4 } | flatten }
| flatten | uniq
| each { |ip| gen_nix_rule $ip }
| str join "\n"

$"[
($rules)
]
" | save -f ./cs2-route-rules.nix
