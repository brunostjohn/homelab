-- BLOCKY
CREATE ROLE blocky_role;
\c blocky
GRANT ALL PRIVILEGES ON DATABASE blocky TO blocky_role;
GRANT ALL ON SCHEMA public TO blocky_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO blocky_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to blocky_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to blocky_role;
CREATE USER blocky WITH PASSWORD '<password>';
GRANT blocky_role TO blocky;

-- OUTLINE
CREATE ROLE outline_role;
\c outline
GRANT ALL PRIVILEGES ON DATABASE outline TO outline_role;
GRANT ALL ON SCHEMA public TO outline_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO outline_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to outline_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to outline_role;
CREATE USER outline WITH PASSWORD '<password>';
GRANT outline_role TO outline;

-- AUTHENTIK
CREATE ROLE authentik_role;
\c authentik
GRANT ALL PRIVILEGES ON DATABASE authentik TO authentik_role;
GRANT ALL ON SCHEMA public TO authentik_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO authentik_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to authentik_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to authentik_role;
CREATE USER authentik WITH PASSWORD '<password>';
GRANT authentik_role TO authentik;

-- NETBOX
CREATE ROLE netbox_role;
\c netbox
GRANT ALL PRIVILEGES ON DATABASE netbox TO netbox_role;
GRANT ALL ON SCHEMA public TO netbox_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO netbox_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to netbox_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to netbox_role;
CREATE USER netbox WITH PASSWORD '<password>';
GRANT netbox_role TO netbox;

-- PAPERLESS
CREATE ROLE paperless_role;
\c paperless
GRANT ALL PRIVILEGES ON DATABASE paperless TO paperless_role;
GRANT ALL ON SCHEMA public TO paperless_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO paperless_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to paperless_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to paperless_role;
CREATE USER paperless WITH PASSWORD '<password>';
GRANT paperless_role TO paperless;

-- LINKWARDEN
CREATE ROLE linkwarden_role;
\c linkwarden
GRANT ALL PRIVILEGES ON DATABASE linkwarden TO linkwarden_role;
GRANT ALL ON SCHEMA public TO linkwarden_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO linkwarden_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to linkwarden_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to linkwarden_role;
CREATE USER linkwarden WITH PASSWORD '<password>';
GRANT linkwarden_role TO linkwarden;

-- NEXTCLOUD
CREATE ROLE nextcloud_role;
\c nextcloud
GRANT ALL PRIVILEGES ON DATABASE nextcloud TO nextcloud_role;
GRANT ALL ON SCHEMA public TO nextcloud_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO nextcloud_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to nextcloud_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to nextcloud_role;
CREATE USER nextcloud WITH PASSWORD '<password>';
GRANT nextcloud_role TO nextcloud;

-- MANYFOLD
CREATE ROLE manyfold_role;
\c manyfold
GRANT ALL PRIVILEGES ON DATABASE manyfold TO manyfold_role;
GRANT ALL ON SCHEMA public TO manyfold_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO manyfold_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to manyfold_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to manyfold_role;
CREATE USER manyfold WITH PASSWORD '<password>';
GRANT manyfold_role TO manyfold;

-- MEALIE
CREATE ROLE mealie_role;
\c mealie
GRANT ALL PRIVILEGES ON DATABASE mealie TO mealie_role;
GRANT ALL ON SCHEMA public TO mealie_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO mealie_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to mealie_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to mealie_role;
CREATE USER mealie WITH PASSWORD '<password>';
GRANT mealie_role TO mealie;

-- JELLYSEERR
CREATE ROLE jellyseerr_role;
\c jellyseerr
GRANT ALL PRIVILEGES ON DATABASE jellyseerr TO jellyseerr_role;
GRANT ALL ON SCHEMA public TO jellyseerr_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO jellyseerr_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to jellyseerr_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to jellyseerr_role;
CREATE USER jellyseerr WITH PASSWORD '<password>';
GRANT jellyseerr_role TO jellyseerr;

-- WINDMILL
CREATE ROLE windmill_role;
\c windmill
GRANT ALL PRIVILEGES ON DATABASE windmill TO windmill_role;
GRANT ALL ON SCHEMA public TO windmill_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO windmill_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to windmill_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to windmill_role;
CREATE USER windmill WITH PASSWORD '<password>';
GRANT windmill_role TO windmill;

-- RALLY
CREATE ROLE rally_role;
\c rally
GRANT ALL PRIVILEGES ON DATABASE rally TO rally_role;
GRANT ALL ON SCHEMA public TO rally_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO rally_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to rally_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to rally_role;
CREATE USER rally WITH PASSWORD '<password>';
GRANT rally_role TO rally;

-- MEMOS
CREATE ROLE memos_role;
\c memos
GRANT ALL PRIVILEGES ON DATABASE memos TO memos_role;
GRANT ALL ON SCHEMA public TO memos_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO memos_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to memos_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to memos_role;
CREATE USER memos WITH PASSWORD '<password>';
GRANT memos_role TO memos;

-- VAULTWARDEN
CREATE ROLE vaultwarden_role;
\c vaultwarden
GRANT ALL PRIVILEGES ON DATABASE vaultwarden TO vaultwarden_role;
GRANT ALL ON SCHEMA public TO vaultwarden_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO vaultwarden_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to vaultwarden_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to vaultwarden_role;
CREATE USER vaultwarden WITH ENCRYPTED PASSWORD '<password>';
GRANT vaultwarden_role TO vaultwarden;

-- CODER
CREATE ROLE coder_role;
\c coder
GRANT ALL PRIVILEGES ON DATABASE coder TO coder_role;
GRANT ALL ON SCHEMA public TO coder_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO coder_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to coder_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to coder_role;
CREATE USER coder WITH PASSWORD '<password>';
GRANT coder_role TO coder;

-- CROWDSEC
CREATE ROLE crowdsec_role;
\c crowdsec
GRANT ALL PRIVILEGES ON DATABASE crowdsec TO crowdsec_role;
GRANT ALL ON SCHEMA public TO crowdsec_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO crowdsec_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to crowdsec_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to crowdsec_role;
CREATE USER crowdsec WITH PASSWORD '<password>';
GRANT crowdsec_role TO crowdsec;

-- NOCODB
CREATE ROLE nocodb_role;
\c nocodb
GRANT ALL PRIVILEGES ON DATABASE nocodb TO nocodb_role;
GRANT ALL ON SCHEMA public TO nocodb_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO nocodb_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to nocodb_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to nocodb_role;
CREATE USER nocodb WITH PASSWORD '<password>';
GRANT nocodb_role TO nocodb;

-- PLANE
CREATE ROLE plane_role;
\c plane
GRANT ALL PRIVILEGES ON DATABASE plane TO plane_role;
GRANT ALL ON SCHEMA public TO plane_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO plane_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to plane_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to plane_role;
CREATE USER plane WITH PASSWORD '<password>';
GRANT plane_role TO plane;

-- ONEUPTIME
CREATE ROLE oneuptime_role;
\c oneuptime
GRANT ALL PRIVILEGES ON DATABASE oneuptime TO oneuptime_role;
GRANT ALL ON SCHEMA public TO oneuptime_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO oneuptime_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to oneuptime_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to oneuptime_role;
CREATE USER oneuptime WITH PASSWORD '<password>';
GRANT oneuptime_role TO oneuptime;

-- GRAFANA
CREATE ROLE grafana_role;
\c grafana
GRANT ALL PRIVILEGES ON DATABASE grafana TO grafana_role;
GRANT ALL ON SCHEMA public TO grafana_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO grafana_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to grafana_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to grafana_role;
CREATE USER grafana WITH PASSWORD '<password>';
GRANT grafana_role TO grafana;

-- ZIPLINE
CREATE ROLE zipline_role;
\c zipline
GRANT ALL PRIVILEGES ON DATABASE zipline TO zipline_role;
GRANT ALL ON SCHEMA public TO zipline_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO zipline_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to zipline_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to zipline_role;
CREATE USER zipline WITH PASSWORD '<password>';
GRANT zipline_role TO zipline;

-- INFISICAL
CREATE ROLE infisical_role;
\c infisical
GRANT ALL PRIVILEGES ON DATABASE infisical TO infisical_role;
GRANT ALL ON SCHEMA public TO infisical_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO infisical_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to infisical_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to infisical_role;
CREATE USER infisical WITH PASSWORD '<password>';
GRANT infisical_role TO infisical;

-- GRIST
CREATE ROLE grist_role;
\c grist
GRANT ALL PRIVILEGES ON DATABASE grist TO grist_role;
GRANT ALL ON SCHEMA public TO grist_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO grist_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to grist_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to grist_role;
CREATE USER grist WITH PASSWORD '<password>';
GRANT grist_role TO grist;

-- SILLY BOT
CREATE ROLE sillybot_role;
\c sillybot
GRANT ALL PRIVILEGES ON DATABASE sillybot TO sillybot_role;
GRANT ALL ON SCHEMA public TO sillybot_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO sillybot_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to sillybot_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to sillybot_role;
CREATE USER sillybot WITH PASSWORD '<password>';
GRANT sillybot_role TO sillybot;

-- OPEN-WEBUI
CREATE ROLE openwebui_role;
\c openwebui
GRANT ALL PRIVILEGES ON DATABASE openwebui TO openwebui_role;
GRANT ALL ON SCHEMA public TO openwebui_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO openwebui_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to openwebui_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to openwebui_role;
CREATE USER openwebui WITH PASSWORD '<password>';
GRANT openwebui_role TO openwebui;

-- HOME ASSISTANT
CREATE ROLE homeassistant_role;
\c homeassistant
GRANT ALL PRIVILEGES ON DATABASE homeassistant TO homeassistant_role;
GRANT ALL ON SCHEMA public TO homeassistant_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO homeassistant_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to homeassistant_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to homeassistant_role;
CREATE USER homeassistant WITH PASSWORD '<password>';
GRANT homeassistant_role TO homeassistant;

-- MEDIA STACK --

-- LIDARR
CREATE ROLE lidarr_role;
\c lidarr-logs
GRANT ALL PRIVILEGES ON DATABASE "lidarr-logs" TO lidarr_role;
GRANT ALL ON SCHEMA public TO lidarr_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO lidarr_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to lidarr_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to lidarr_role;
\c lidarr-main
GRANT ALL PRIVILEGES ON DATABASE "lidarr-main" TO lidarr_role;
GRANT ALL ON SCHEMA public TO lidarr_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO lidarr_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to lidarr_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to lidarr_role;
CREATE USER lidarr WITH PASSWORD '<password>';
GRANT lidarr_role TO lidarr;

-- PROWLARR
CREATE ROLE prowlarr_role;
\c prowlarr-logs
GRANT ALL PRIVILEGES ON DATABASE "prowlarr-logs" TO prowlarr_role;
GRANT ALL ON SCHEMA public TO prowlarr_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO prowlarr_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to prowlarr_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to prowlarr_role;
\c prowlarr-main
GRANT ALL PRIVILEGES ON DATABASE "prowlarr-main" TO prowlarr_role;
GRANT ALL ON SCHEMA public TO prowlarr_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO prowlarr_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to prowlarr_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to prowlarr_role;
CREATE USER prowlarr WITH PASSWORD '<password>';
GRANT prowlarr_role TO prowlarr;

-- RADARR
CREATE ROLE radarr_role;
\c radarr-logs
GRANT ALL PRIVILEGES ON DATABASE "radarr-logs" TO radarr_role;
GRANT ALL ON SCHEMA public TO radarr_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO radarr_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to radarr_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to radarr_role;
\c radarr-main
GRANT ALL PRIVILEGES ON DATABASE "radarr-main" TO radarr_role;
GRANT ALL ON SCHEMA public TO radarr_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO radarr_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to radarr_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to radarr_role;
CREATE USER radarr WITH PASSWORD '<password>';
GRANT radarr_role TO radarr;

-- READARR
CREATE ROLE readarr_role;
\c readarr-logs
GRANT ALL PRIVILEGES ON DATABASE "readarr-logs" TO readarr_role;
GRANT ALL ON SCHEMA public TO readarr_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO readarr_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to readarr_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to readarr_role;
\c readarr-main
GRANT ALL PRIVILEGES ON DATABASE "readarr-main" TO readarr_role;
GRANT ALL ON SCHEMA public TO readarr_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO readarr_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to readarr_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to readarr_role;
\c readarr-cache
GRANT ALL PRIVILEGES ON DATABASE "readarr-cache" TO readarr_role;
GRANT ALL ON SCHEMA public TO readarr_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO readarr_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to readarr_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to readarr_role;
CREATE USER readarr WITH PASSWORD '<password>';
GRANT readarr_role TO readarr;

-- SONARR
CREATE ROLE sonarr_role;
\c sonarr-logs
GRANT ALL PRIVILEGES ON DATABASE "sonarr-logs" TO sonarr_role;
GRANT ALL ON SCHEMA public TO sonarr_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO sonarr_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to sonarr_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to sonarr_role;
\c sonarr-main
GRANT ALL PRIVILEGES ON DATABASE "sonarr-main" TO sonarr_role;
GRANT ALL ON SCHEMA public TO sonarr_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO sonarr_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to sonarr_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to sonarr_role;
CREATE USER sonarr WITH PASSWORD '<password>';
GRANT sonarr_role TO sonarr;

-- BAZARR
CREATE ROLE bazarr_role;
\c bazarr
GRANT ALL PRIVILEGES ON DATABASE bazarr TO bazarr_role;
GRANT ALL ON SCHEMA public TO bazarr_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO bazarr_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public to bazarr_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public to bazarr_role;
CREATE USER bazarr WITH PASSWORD '<password>';
GRANT bazarr_role TO bazarr;