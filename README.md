# PostgreSQL Admin Security 

## Introduction

Repository for administration and security management in PostgreSQL 16.
Focus on hardening, RBAC and Business Logic.

## Hardening

Implementation of security policies to control access at the network and socket levels.

- Test 1: Local Access (peer):
	- Validation: Only postgres user can access without a socket password.
	- Result: Successful. Command 'sudo -u postgres' connect correctly.

- Test 2: Red Security (scram-sha-256):
	- Validation: TCP/IP (localhost) connections requires strong password encryption.
	- Command: 'psql -h 127.0.0.1 -U postgres'.
	- Result: Successful. System requests and validates the password.

## Privileges and Roles (RBAC)

Implementation of a Role-Based Access Control hierarchy to ensure the principle of least privilege.

- Test 3: Restricted Access (readonly group):
	- Validation: A user in the read-only group can query data but cannot modify the database structure or content.
	- Command: 'psql -h 127.0.0.1 -U ana_analista -d dba_laboratorio'.
	- Action 1: 'SELECT * FROM ventas.test_herencia;'-> Successful.
    - Action 2: 'INSERT INTO ventas.test_herencia...' -> Permission Denied.
	- Action 3: 'CREATE TABLE ventas.demo...' -> Permission Denied.

- Test 4: Administrative Access (readwrite_group):
	- Validation: The admin user inherits all necesary permissions to manage the business schema.
	- Command: 'psql -h 127.0.0.1 -U bastihan_admin -d dba_laboratorio'.
	- Result: Successful. The user can create tables, insert data, and manage the 'ventas' schema.

### Key Implementation Features:
	- Schema Isolation: Revoked all default permissions from the 'public' schema to prevent unauthorized object creation.
	- Inheritance: Roles are structured so that 'readwrite_grp' inherits from 'readonly_grp', centralizing permission management.
	- Scalability: Configured 'ALTER DEFAULT PRIVILEGES' to ensure future tables are automatically accessible to the audit/read roles.

## Advanced SQL and Auditing (Window Functions)

Implementation of analytical queries to monitor user activity patterns without losing data granularity.

- test 5: Business Logic and Traffic Analysis:
	- Validation: Analysis of KB downloaded per session, cumulative totals, and comparative growth between accesses.
	- Script: queries/01_window_lab.sql
	- Action 1: Calculate cumulative sum per user using SUM() OVER(PARTITION BY ...).
	- Action 2: Identify top consumers with DENSE_RANK().
	- Action 3: Detect traffic spikes by comparing current vs previous session using LAG().
