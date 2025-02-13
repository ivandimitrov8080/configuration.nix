#!/usr/bin/env node

import fs from "node:fs";

const steamCsgoServerListUrl =
	"https://api.steampowered.com/ISteamApps/GetSDRConfig/v1/?appid=730";
const steamDotaServerListUrl =
	"https://api.steampowered.com/ISteamApps/GetSDRConfig/v1/?appid=570";

const cs2Servers = await fetch(steamCsgoServerListUrl).then((data) =>
	data.json(),
);
const dotaServers = await fetch(steamDotaServerListUrl).then((data) =>
	data.json(),
);
const ipList = [...new Set(getIps(cs2Servers).concat(getIps(dotaServers)))];
const cs2Rules = `[${ipList.map((ip) => createNixRule(ip)).join("")}
]
`;

function pickServer(server) {
	getServerList().filter((serverData) => serverData.desc != server);
}

function getServerList(servers) {
	return Object.values(servers.pops)
		.filter((server) => server.desc !== undefined)
		.filter(
			(server) => server.relays !== undefined && server.relays.length > 0,
		);
}

function getIps(servers) {
	return getServerList(servers)
		.map((s) => s.relays)
		.map((r) => r.map((v) => v.ipv4))
		.flat(1);
}

export function getServerNames() {
	return getServerList().map((server) => server.desc);
}

function createNixRule(ip) {
	return `
  {
    To = "${ip}/32";
    Priority = 5;
  }`;
}

fs.writeFileSync("./cs2-route-rules.nix", cs2Rules);
