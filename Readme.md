# IOT Network Analysis Middleware

This repository forms the middlware section of the IOT Network Analysis project, which attempted to build a proof of concept tool for passive security analysis of IoT devices.

This part of the project forms the database and API layer between the backend and the frontend. As a part of this, we have three major components:
- Postgres
- Postgraphile
- Adminer

Postgres is our relational database, while postgraphile is an API wrapper enabling a graphql server to run on top of our database, allowing easy access to both the graphiql playground and Graphql server. 

Adminer is a temporary addition, enabling easy debugging of the database while we're developing. It's likely to be removed at somepoint.

### How do I run it

*Prerequestites* 
- Docker-compose
- Docker

To run the project, simple use:

`docker-compose up`

Once the servers have started, you should have the output of all three services. Check for errors, and check connectivity. The ports for each service are:

- GraphQL => http://localhost:5000/graphql

- GraphiQL => http://localhost:5000/graphiql

- Adminer => http://localhost:8080/adminer

- Postgres (No Web GUI) => localhost:5432
