FROM postgres:15

ENV POSTGRES_USER=root
ENV POSTGRES_PASSWORD=root
ENV POSTGRES_DB=my_database_pg

COPY sql/core.sql sql/data.sql sql/views.sql sql/init.sql /docker-entrypoint-initdb.d/