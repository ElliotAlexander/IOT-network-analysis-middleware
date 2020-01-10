DROP SCHEMA IF EXISTS example CASCADE;
DROP SCHEMA IF EXISTS example_private CASCADE;
CREATE SCHEMA example_private; 
CREATE SCHEMA example;

CREATE EXTENSION pgcrypto; 

CREATE TABLE IF NOT EXISTS devices(
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

CREATE TABLE IF NOT EXISTS port_scanning(
   uuid BYTEA PRIMARY KEY,
   open_tcp_ports VARCHAR,
   open_udp_ports VARCHAR,
   last_scanned TIMESTAMP 
);

CREATE TABLE IF NOT EXISTS device_stats(
   uuid BYTEA PRIMARY KEY,
   packet_count BIGINT,
   https_packet_count BIGINT,
   data_transferred BIGINT,
   data_in BIGINT,
   data_out BIGINT
);

CREATE TABLE IF NOT EXISTS device_stats_over_time(
   uuid BYTEA,
   timestamp TIMESTAMP,
   packet_count BIGINT,
   https_packet_count BIGINT,
   data_transferred BIGINT,
   data_in BIGINT,
   data_out BIGINT,
   PRIMARY KEY(uuid, timestamp)
);

CREATE TABLE IF NOT EXISTS device_dns_storage(
   uuid BYTEA,
   url VARCHAR(100),
   PRIMARY KEY(uuid, url)
);

CREATE FUNCTION getDNSQueries(a bytea) RETURNS SETOF VARCHAR(100) AS $$ SELECT url FROM device_dns_storage WHERE uuid=a;$$ LANGUAGE SQL IMMUTABLE STRICT;

CREATE TYPE example.jwt_token AS (
  role TEXT,
  exp INTEGER,
  person_id INTEGER,
  is_admin BOOLEAN,
  username VARCHAR
);

CREATE TABLE IF NOT EXISTS example_private.person_account (
  role TEXT,
  exp INTEGER,
  person_id INTEGER,
  is_admin BOOLEAN,
  username VARCHAR,
  password_hash TEXT,
  email TEXT
);

CREATE FUNCTION example.authenticate(
  email text,
  password text
) RETURNS example.jwt_token AS $$
DECLARE
  account example_private.person_account;
BEGIN
  SELECT a.* INTO account
    FROM example_private.person_account AS a
    WHERE a.email = authenticate.email;

  IF account.password_hash = crypt(password, account.password_hash) THEN
    RETURN (
      'person_role',
      extract(epoch from now() + interval '7 days'),
      account.person_id,
      account.is_admin,
      account.username
    )::example.jwt_token;
  ELSE
    RETURN null;
  END IF;
END;
$$ LANGUAGE plpgsql strict security definer;

INSERT INTO example_private.person_account (email, password_hash) VALUES (
  'test',
  crypt('test',gen_salt('bf'))
);