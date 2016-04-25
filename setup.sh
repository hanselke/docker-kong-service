#!/bin/sh

# Setting up the proper database
if [ -n "$DATABASE" ]; then
  echo -e '\ndatabase: "'$DATABASE'"' >> /etc/kong/kong.yml
fi

if [ -n "$POSTGRES_HOST" ]; then
  sed -ie "s/host: \"kong-database\"/host: \"$POSTGRES_HOST\"/" /etc/kong/kong.yml
fi

if [ -n "$POSTGRES_PORT" ]; then
  sed -ie "s/port: 5432/port: $POSTGRES_PORT/" /etc/kong/kong.yml
fi

if [ -n "$POSTGRES_DATABASE" ]; then
  sed -ie "s/database: kong/database: $POSTGRES_DATABASE/" /etc/kong/kong.yml
fi

if [ -n "$POSTGRES_USER" ]; then
  sed -ie "s/user: kong/user: $POSTGRES_USER/" /etc/kong/kong.yml
fi

if [ -n "$POSTGRES_PASSWORD" ]; then
  sed -ie "s/password: kong/password: $POSTGRES_PASSWORD/" /etc/kong/kong.yml
fi
