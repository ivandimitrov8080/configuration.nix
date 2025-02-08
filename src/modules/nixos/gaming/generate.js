#!/usr/bin/env node

import fs from "node:fs"

const steamCsgoServerListUrl = "https://api.steampowered.com/ISteamApps/GetSDRConfig/v1/?appid=730"

const servers = await fetch(steamCsgoServerListUrl).then(data => data.json());
const ipList = getServerList().map(s => s.relays).map(r => r.map(v => v.ipv4)).flat(1)
const cs2Rules = `[${ipList.map(ip => createNixRule(ip)).join("")}
]
`

function pickServer(server) {
    getServerList()
        .filter(serverData => serverData.desc != server)
}

function getServerList() {
    return Object.values(servers.pops)
        .filter(server => server.desc !== undefined)
        .filter(server => server.relays !== undefined && server.relays.length > 0)
}

export function getServerNames() {
    return getServerList().map(server => server.desc)
}

function createNixRule(ip) {
    return `
  {
    To = "${ip}/32";
    Priority = 5;
  }`
}

fs.writeFileSync("./cs2-route-rules.nix", cs2Rules)
