# Deployment

This document covers deployment requirements and steps.

Before you start, make sure you have available the following services:
1. PostgreSQL >= 9.5, and have created the database you want to connect to and use.

Deployment consists of 5 parts:
1. Make sure your required services are running
2. Install any required packages (first time only)
2. Set environment variables
3. Run migrations (if needed)
4. Run a startup command

## Required Packages

Elixir applications include an embedded runtime, meaning you don't need to have the language installed.
Usually a libc implementation and a few other things are sufficient.

For Centos 7, I have the following packages:
`yum install -y wget gcc gcc-c++ glibc-devel make ncurses-devel openssl-devel autoconf java-1.8.0-openjdk-devel git zip unzip`

## Runtime Environment Variables

Various environment variables are required or must be set to run this application - what they are, if they are required, and what they do is below.

1. DATABASE_HOST - required - database host name
2. DATABASE_USER - required - user name for the database connection
3. DATABASE_PASSWORD - required - password for the database connection
4. DATABASE_NAME - optional, defaults to `yellr_prod` - the name of the application database
5. DATABASE_PORT - optional, defaults to `5432` - the port for the database connection
6. PORT - required - the http port on which to run the server
7. API_KEY - required - specifies the secret API key used to post build updates.

## Database Migrations

Provided you've already created your database, or it exists from a previous installation, and environment variables are set, run migrations with:
`.bin/yellr migrate`

## Running the Program

Set your environment variables (in your environment, or in-line) and use one of the following commands:

1. `./bin/yellr start` - start as a background daemon
2. `./bin/yellr stop` - stop the background daemon
3. `./bin/yellr foreground` - run the program in the foreground on the current console
