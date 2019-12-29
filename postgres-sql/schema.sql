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


CREATE TABLE IF NOT EXISTS device_stats(
   uuid BYTEA PRIMARY KEY,
   packet_count BIGINT,
   https_packet_count BIGINT,
   data_transferred BIGINT,
   data_in BIGINT,
   data_out BIGINT
);

CREATE TABLE IF NOT EXISTS port_scanning(
   uuid BYTEA PRIMARY KEY,
   open_tcp_ports VARCHAR,
   open_udp_ports VARCHAR,
   last_scanned TIMESTAMP 
);

CREATE TABLE IF NOT EXISTS packet_counts_over_time(
   uuid BYTEA,
   timestamp TIMESTAMP,
   packet_count BIGINT,
   https_packet_count BIGINT,
   PRIMARY KEY(uuid, timestamp)
);

CREATE TABLE IF NOT EXISTS device_dns_storage(
   uuid BYTEA,
   url VARCHAR(100),
   PRIMARY KEY(uuid, url)
);

CREATE FUNCTION getDNSQueries(a bytea) RETURNS SETOF VARCHAR(100) AS $$ SELECT url FROM device_dns_storage WHERE uuid=a;$$ LANGUAGE SQL IMMUTABLE STRICT;
