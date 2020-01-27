# FROM node:alpine
FROM graphile/postgraphile
LABEL description="Instant high-performance GraphQL API for your PostgreSQL database https://github.com/graphile/postgraphile"

RUN npm install pg graphile-build-pg@next postgraphile-core@next graphile-build graphql
RUN npm install postgraphile-plugin-connection-filter
RUN npm install @graphile/subscriptions-lds @graphile/pg-pubsub@next
RUN npm install -g @graphile/subscriptions-lds
RUN npm install

EXPOSE 5000
