#!/bin/bash

if [[ $EUID -eq 0 ]]; then
    error "This script should not be run using sudo or as the root user"
    exit 1
 fi





 npx postgraphile -c postgres://postgres:tallest-tree@localhost/postgres --watch --enhance-graphiql --dynamic-json
