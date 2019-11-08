CREATE TABLE IF NOT EXISTS devices(
   uuid VARCHAR(128) PRIMARY KEY,
   device_nickname VARCHAR(100) UNIQUE NOT NULL,
   device_hostname VARCHAR(100),
   internal_ip_v4 VARCHAR(20),
   internal_ip_v6 VARCHAR(40),
   currently_active BOOLEAN NOT NULL,
   last_seen TIMESTAMP,
   first_seen TIMESTAMP NOT NULL,
   set_ignored BOOLEAN NOT NULL,
   device_type VARCHAR(100)
);
