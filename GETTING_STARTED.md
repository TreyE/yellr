# Get Started as a Developer

This tells you how to get going with development of Yellr.  There are a couple of different paths available, depending on what you are after.

## IF YOU ARE LAZY/AWESOME

If you want to skip all the installation and just get a sense of what is going on, run:
```
./docker_testing_status_report
```

You will find a zip file in `docker/testing/development_status_report.zip`.
Inside of that file, open up `doc/index.html` to begin exploring.

## If you'd actually like to develop and and contribute code

First - this assumes you have Elixir 1.9.1 installed.  Install via asdf or your preferred version manager - or just directly.

You will need to:
1. Fetch Dependencies
2. Initialize the Database
3. Start your server

### Fetch dependencies

In your root, run `mix deps.get`.

Then change directory into `assets`, and run `yarn install`.

### Initialize the Database

Make sure you are running a postgres instance.

Database configuration for development lives in `config/dev.exs`.
Edit it to have the correct settings.

In the root directory, run `mix ecto.create; mix ecto.migrate`.

From now on you can start the server with `mix phx.server`.

# Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix