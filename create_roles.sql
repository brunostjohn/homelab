CREATE ROLE dbname_role;
GRANT CONNECT ON DATABASE dbname TO dbname_role;
GRANT ALL PRIVILEGES ON DATABASE dbname TO dbname_role;
CREATE USER dbname WITH PASSWORD '<password>';
GRANT dbname_role TO dbname;

-- BLOCKY
CREATE ROLE blocky_role;
GRANT ALL PRIVILEGES ON DATABASE blocky TO blocky_role;
CREATE USER blocky WITH PASSWORD '<password>';
GRANT blocky_role TO blocky;

-- AUTHENTIK
CREATE ROLE authentik_role;
GRANT ALL PRIVILEGES ON DATABASE authentik TO authentik_role;
CREATE USER authentik WITH PASSWORD '<password>';
GRANT authentik_role TO authentik;

-- NETBOX
CREATE ROLE netbox_role;
GRANT ALL PRIVILEGES ON DATABASE netbox TO netbox_role;
CREATE USER netbox WITH PASSWORD '<password>';
GRANT netbox_role TO netbox;

-- PAPERLESS
CREATE ROLE paperless_role;
GRANT ALL PRIVILEGES ON DATABASE paperless TO paperless_role;
CREATE USER paperless WITH PASSWORD '<password>';
GRANT paperless_role TO paperless;

-- LINKWARDEN
CREATE ROLE linkwarden_role;
GRANT ALL PRIVILEGES ON DATABASE linkwarden TO linkwarden_role;
CREATE USER linkwarden WITH PASSWORD '<password>';
GRANT linkwarden_role TO linkwarden;

-- NEXTCLOUD
CREATE ROLE nextcloud_role;
GRANT ALL PRIVILEGES ON DATABASE nextcloud TO nextcloud_role;
CREATE USER nextcloud WITH PASSWORD '<password>';
GRANT nextcloud_role TO nextcloud;

-- MANYFOLD
CREATE ROLE manyfold_role;
GRANT ALL PRIVILEGES ON DATABASE manyfold TO manyfold_role;
CREATE USER manyfold WITH PASSWORD '<password>';
GRANT manyfold_role TO manyfold;

-- MEALIE
CREATE ROLE mealie_role;
GRANT ALL PRIVILEGES ON DATABASE mealie TO mealie_role;
CREATE USER mealie WITH PASSWORD '<password>';
GRANT mealie_role TO mealie;

-- JELLYSEERR
CREATE ROLE jellyseerr_role;
GRANT ALL PRIVILEGES ON DATABASE jellyseerr TO jellyseerr_role;
CREATE USER jellyseerr WITH PASSWORD '<password>';
GRANT jellyseerr_role TO jellyseerr;

-- WINDMILL
CREATE ROLE windmill_role;
GRANT ALL PRIVILEGES ON DATABASE windmill TO windmill_role;
CREATE USER windmill WITH PASSWORD '<password>';
GRANT windmill_role TO windmill;