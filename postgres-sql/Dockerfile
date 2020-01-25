FROM postgres

RUN apt-get update && apt-get install -y git
RUN apt-get update \
    && apt-get install -f -y --no-install-recommends \
        software-properties-common \
        build-essential \
        pkg-config \
        git \
        postgresql-server-dev-$PG_MAJOR \
    && add-apt-repository "deb http://ftp.debian.org/debian testing main contrib" \
    && apt-get update && apt-get install -f -y libprotobuf-c-dev \
    && rm -rf /var/lib/apt/lists/*
RUN apt-get install -y libpq-dev build-essential
RUN git clone https://github.com/eulerto/wal2json -b master --single-branch \
    && cd /wal2json \
    && make && make install \
    && cd / \
    && rm -rf wal2json
ADD ./schema.sql /docker-entrypoint-initdb.d/schema.sql