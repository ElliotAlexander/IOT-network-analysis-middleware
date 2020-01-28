DROP SCHEMA IF EXISTS authentication CASCADE;
DROP SCHEMA IF EXISTS authentication_private CASCADE;
DROP SCHEMA IF EXISTS backend CASCADE;
CREATE SCHEMA authentication_private; 
CREATE SCHEMA authentication;
CREATE SCHEMA backend;

CREATE ROLE anonymous;
GRANT anonymous TO current_user;

-- When logged in, the user should have the role medium_user
CREATE ROLE medium_user;
GRANT medium_user TO current_user;

-- We need this for login tokens
CREATE EXTENSION pgcrypto; 


CREATE TABLE IF NOT EXISTS backend.devices(
   uuid BYTEA PRIMARY KEY,
   mac_addr VARCHAR(64) NOT NULL,
   device_nickname VARCHAR(100),
   device_hostname VARCHAR(100),
   internal_ip_v4 VARCHAR(20),
   internal_ip_v6 VARCHAR(40),
   currently_active BOOLEAN NOT NULL,
   last_seen TIMESTAMP,
   first_seen TIMESTAMP NOT NULL,
   set_ignored BOOLEAN NOT NULL,
   device_type VARCHAR(100)
);
CREATE TABLE IF NOT EXISTS backend.device_data_sum_over_time(
  timestamp TIMESTAMP, 
  data_transferred BIGINT,
  data_in BIGINT,
  data_out BIGINT,
  PRIMARY KEY(timestamp)
);

CREATE TABLE IF NOT EXISTS backend.port_scanning(
   uuid BYTEA PRIMARY KEY,
   open_tcp_ports VARCHAR,
   open_udp_ports VARCHAR,
   last_scanned TIMESTAMP 
);

CREATE TABLE IF NOT EXISTS backend.device_stats(
   uuid BYTEA PRIMARY KEY,
   packet_count BIGINT,
   https_packet_count BIGINT,
   data_transferred BIGINT,
   data_in BIGINT,
   data_out BIGINT
);

CREATE TABLE IF NOT EXISTS backend.device_stats_over_time(
   uuid BYTEA,
   timestamp TIMESTAMP,
   packet_count BIGINT,
   https_packet_count BIGINT,
   data_transferred BIGINT,
   data_in BIGINT,
   data_out BIGINT,
   PRIMARY KEY(uuid, timestamp)
);

CREATE TABLE IF NOT EXISTS backend.device_dns_storage(
   uuid BYTEA,
   url VARCHAR(100),
   PRIMARY KEY(uuid, url)
);

CREATE FUNCTION backend.getDNSQueries(a bytea) RETURNS SETOF VARCHAR(100) AS $$ SELECT url FROM backend.device_dns_storage WHERE uuid=a;$$ LANGUAGE SQL IMMUTABLE STRICT;

CREATE TYPE authentication.jwt_token AS (
  role TEXT,
  exp INTEGER,
  person_id INTEGER,
  is_admin BOOLEAN,
  username VARCHAR
);

CREATE TABLE IF NOT EXISTS authentication_private.person_account (
  role TEXT,
  exp INTEGER,
  person_id INTEGER,
  is_admin BOOLEAN,
  username VARCHAR,
  password_hash TEXT,
  email TEXT
);

CREATE FUNCTION authentication.authenticate(
  email text,
  password text
) RETURNS authentication.jwt_token AS $$
DECLARE
  account authentication_private.person_account;
BEGIN
  SELECT a.* INTO account
    FROM authentication_private.person_account AS a
    WHERE a.email = authenticate.email;

  IF account.password_hash = crypt(password, account.password_hash) THEN
    RETURN (
      'medium_user',
      extract(epoch from now() + interval '7 days'),
      account.person_id,
      account.is_admin,
      account.username
    )::authentication.jwt_token;
  ELSE
    RETURN null;
  END IF;
END;
$$ LANGUAGE plpgsql strict security definer;

INSERT INTO authentication_private.person_account (role,person_id,username, email, password_hash) VALUES (
  'medium_user',
  '1',
  'test',
  'test',
  crypt('test',gen_salt('bf'))
);


CREATE TABLE IF NOT EXISTS backend.ip_address_location(
    uuid BYTEA,
    ip_address VARCHAR(50),
    latitude NUMERIC,
    longitude NUMERIC,
    last_scanned TIMESTAMP,
    is_tor_node BOOLEAN,
    PRIMARY KEY(uuid, ip_address)
);

GRANT USAGE ON SCHEMA authentication TO anonymous; 
GRANT USAGE ON SCHEMA backend TO medium_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA backend TO medium_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA backend TO medium_user;
GRANT USAGE ON SCHEMA authentication TO anonymous;
