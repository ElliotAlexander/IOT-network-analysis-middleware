CREATE TABLE IF NOT EXISTS devices(
   uuid BYTEA PRIMARY KEY,
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
   data_transferred BIGINT
);

CREATE TABLE IF NOT EXISTS port_scanning(
   uuid BYTEA PRIMARY KEY,
   open_tcp_ports VARCHAR,
   open_udp_ports VARCHAR,
   last_scanned TIMESTAMP 
);