-- RBAC CONFIGURATION

-- INITIAL HARDENING:
-- We revoke creation permissions in SCHEMA public to avoid risks.
REVOKE CREATE ON SCHEMA public FROM PUBLIC;

-- DEFINITION OF GROUP ROLES:
-- We use NOLOGIN because they are group roles, not users.
CREATE ROLE readonly_grp NOLOGIN;
CREATE ROLE readwrite_grp NOLOGIN;

-- STRUCTURE:
CREATE SCHEMA ventas;

-- PRIVILEGES:
-- Reading group needs USAGE to enter the SCHEMA.
GRANT USAGE ON SCHEMA ventas TO readonly_grp;
GRANT SELECT ON ALL TABLES IN SCHEMA ventas TO readonly_grp;

-- We configure permissions for tables that will be created in the future.
ALTER DEFAULT PRIVILEGES IN SCHEMA ventas GRANT SELECT ON TABLES to readonly_grp;

-- Writing group inherits reading and gets CREATE permission.
GRANT readonly_grp TO readwrite_grp;
GRANT CREATE ON SCHEMA ventas TO readwrite_grp;

-- ADMINISTRATIVE USERS:
-- Personal user that inherits powers from writing group.
CREATE USER bastihan_admin WITH PASSWORD 'strongpassword';
GRANT readwrite_grp TO bastihan_admin;





