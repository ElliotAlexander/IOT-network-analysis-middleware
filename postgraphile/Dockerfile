FROM node:alpine
LABEL description="Instant high-performance GraphQL API for your PostgreSQL database https://github.com/graphile/postgraphile"

RUN npm install -g postgraphile
RUN npm install -g postgraphile-plugin-connection-filter
RUN npm install @graphile/subscriptions-lds

EXPOSE 5000

ENTRYPOINT ["postgraphile", "-c", "postgres://postgres:tallest-tree@postgres:5432","--owner-connection", "postgres://postgres:tallest-tree@postgres:5432", "-n", "0.0.0.0", "-o", "--jwt-token-identifier", "authentication.jwt_token","--jwt-secret", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c", "--watch", "-s", "authentication,backend", "--default-role", "anonymous", "--live", "--append-plugins", "@graphile/subscriptions-lds" ]
