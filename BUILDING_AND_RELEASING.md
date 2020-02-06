# Building and Releasing

This file will point you in the right direction if you just want to build a release or get one deployed.

## Configure Your Keys

Before doing any builds, for production or otherwise, make sure to edit the `config/prod.secret.exs` file.  It contains two settings where you need to provide secret keys.  These keys are used to encrypt the client side session and the JWT tokens for users.  The two strings you need to replace are specially marked.  Any sufficiently long base64 string of bytes should do, but in a pinch you can generate some values using `mix phx.gen.secret`.  While you should probably keep the values consistent over the application lifetime, the worst that can happen is the user will need to log back in after an application deployment.  Changing the keys doesn't cause any real damage - it just might annoy a user.

## Build and Release Commands

There are a variety of commands available to create release packages:
1. `docker_build_release_image` - Build a release image and push it up, then generate the corresponding compose file.  **Make sure** to edit this file to have the correct host name (i.e. your account) before you run this.  You will then find the compose file in  `docker_releases/<GIT_COMMIT_SHA>/docker-compose.yml`.
2. `docker_release_zip` - Build a zip package that also contains a script to run the application, and it's database, as a docker composed service.  It comes with a script, called `docker_run_release_server` that will compose for you.  If you want  to play with the deployment settings check out the compose and docker files in the zip's `docker/deploy` directory.
3. `docker_compile_release` - Cross-compile a stand-alone zip for CentOS7 that you can deploy on your own CentOS7 server.  Contains the application and a file describing how to configure the environment, database, and the environment variables you care about.  Use this when you don't want to deploy to a docker instance, but run it on your own CentOS7 server and host your own database.
4. `compile_release` - Build a release into the '_build' directory.  **This release will be targeted to the machine on which you did the building**.  You should really only use this to see if you can run the server locally and for release debugging.

## Deployment Commands

There is really only one concrete deployment command, `docker_run_release_server`.  It is copied into the release zip file for a docker deployment.  You will want to edit the `docker/deploy/docker-compose.yml` file, in order to set the `API_KEY` setting that will be used to report build resuts by CI tools.
