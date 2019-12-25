FROM node:alpine
LABEL description="Instant high-performance GraphQL API for your PostgreSQL database https://github.com/graphile/postgraphile"

RUN npm install -g postgraphile
RUN npm install -g postgraphile-plugin-connection-filter

EXPOSE 5000
ENTRYPOINT ["postgraphile", "-c", "postgres://postgres:tallest-tree@postgres:5432", "-n", "0.0.0.0", "-o"] 
