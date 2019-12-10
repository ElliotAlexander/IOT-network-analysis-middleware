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

CREATE TABLE IF NOT EXISTS packet_counts_over_time(
   uuid BYTEA,
   timestamp TIMESTAMP, 
   packet_count BIGINT,
   https_packet_count BIGINT,
   PRIMARY KEY (uuid, timestamp)
);

create function traffic(a bytea) returns packet_counts_over_time as $$ select * from packet_counts_over_time where uuid = a $$ LANGUAGE sql STABLE;

create function traffic_for_uuid(a bytea) returns packet_counts_over_time as $$ select * from packet_counts_over_time where uuid = a $$ LANGUAGE sql STABLE;
