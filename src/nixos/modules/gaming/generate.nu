#!/usr/bin/env nu
def gen_nix_rule [ip] { $'  {
    To = "($ip)/32";
    Priority = 5;
  }' }
let apps = ["https://api.steampowered.com/ISteamApps/GetSDRConfig/v1/?appid=730", "https://api.steampowered.com/ISteamApps/GetSDRConfig/v1/?appid=570"]
let ips = $apps | each { |u| http get $u | get pops | transpose server info | each { |srv| $srv.info.relays?.ipv4 } | flatten } | flatten | uniq
let rules = $ips | each { |ip| gen_nix_rule $ip } | str join "\n"
$"[
($rules)
]
" | save -f ./steam-route-rules.nix
