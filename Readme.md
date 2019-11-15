# GDP Group 31 Middlewere

This part of the project forms the database and API layer between the backend and the frontend. As a part of this, we have two major components:
- Postgres
- Postgraphile

Postgres is our relational database, while postgraphile is an API wrapper enabling a graphql server to run on top of our database, allowing easy access to both the graphiql playground and Graphql server. 

### How do I run it

*Prerequestites* 
- Docker-compose
- Docker

To run the project, simple use:

`docker-compose up`

Once the servers have started, you should have the output of all three services. Check for errors, and check connectivity. The ports for each service are:

GraphQL => http://localhost:5000/graphql
GraphiQL => http://localhost:5000/graphiql
Adminer => http://localhost:8080/adminer
Postgres (No Web GUI) => localhost:5432
