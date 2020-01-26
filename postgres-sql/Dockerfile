FROM postgres

RUN apt-get update && apt-get install -y git
RUN rm -R /var/lib/postgres &&\
    mkdir -p /var/lib/postgres &&\
    chmod 775 /var/lib/postgres&&\
    chown postgres /var/lib/postgres
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8     
USER postgres
RUN initdb -D '/var/lib/postgres/data' --locale en_US.utf8 --encoding=UTF8
RUN locale -a
USER root
RUN apt-get update \
    && apt-get install -f -y --no-install-recommends \
        software-properties-common \
        build-essential \
        pkg-config \
        git \
        postgresql-server-dev-$PG_MAJOR \
        postgresql-common \
        postgresql-server-dev-all \
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