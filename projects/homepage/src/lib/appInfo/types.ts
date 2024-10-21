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
	| "vaultwarden";

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
}

export type AppInfoMap = Record<HostedApp, AppInfo>;
