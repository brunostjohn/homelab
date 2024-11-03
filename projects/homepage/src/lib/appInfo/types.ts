import type { Component } from "svelte";

export type HostedApp =
	| "audiobookshelf"
	| "bazarr"
	| "grafana"
	| "homeassistant"
	| "immich"
	| "jellyfin"
	| "jellyseerr"
	| "lidarr"
	| "linkwarden"
	| "mealie"
	| "memos"
	| "minio"
	| "netbox"
	| "nextcloud"
	| "ollama"
	| "paperless"
	| "prowlarr"
	| "qbittorrent"
	| "radarr"
	| "readarr"
	| "romm"
	| "sabnzbd"
	| "sonarr"
	| "unifinvr"
	| "vaultwarden"
	| "perplexity"
	| "grist"
	| "nocodb"
	| "rally"
	| "stirlingpdf"
	| "ittools"
	| "searxng"
	| "manyfold"
	| "plane"
	| "windmill"
	| "coder"
	| "opengist"
	| "kibana"
	| "authentik"
	| "emqx"
	| "zigbee2mqtt"
	| "rabbitmq"
	| "truecommand"
	| "truenasscale"
	| "proxmox"
	| "unifinetwork"
	| "traefik"
	| "idrac"
	| "longhorn"
	| "infisical"
	| "sharex"
	| "pingvinshare";

export type AppCategory =
	| "entertainment"
	| "productivity"
	| "personalCloud"
	| "smartHome"
	| "serverManagement";

export interface AppInfo {
	name: string;
	screenshotUrls: string[];
	description: string;
	url: (domain: string) => string;
	tags: string[];
	keywords: string[];
	category: AppCategory;
	iconComponent: Component<{ class: string }>;
	iconPadding?: "s" | "m";
	iconFill?: boolean;
}

export type AppInfoMap = Record<HostedApp, AppInfo>;
