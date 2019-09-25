Cloudpebble Composed
====================

This repo contains the key components of CloudPebble as submodules. It also contains a
`docker-compose` file that will assemble all of them into something that runs like a
real CloudPebble instance.

Getting Started
---------------

1. Install [Docker Toolbox](https://www.docker.com/docker-toolbox) (Mac, Windows),
   or otherwise get docker and docker-compose into a working state (Linux).
2. Enter a shell with docker set up appropriately (e.g. via "Docker Quickstart Terminal")
3. `git clone --recursive git@github.com:iSevenDays/cloudpebble-composed.git && cd cloudpebble-composed`
4. Open docker-compose.yml and set your local IP address from Network -> Settings (IMPORTANT)
5. `./dev_setup.sh` (this will take a while)
6. `docker-compose up`
7. Register a local account at http://your_ip_address/accounts/register/
8. Login with local account at http://your_ip_address/accounts/login/ (you have to login when the docker restarts)

At the end of this, you will have seven Docker containers running. The CloudPebble-specific ones
should pick up most changes without being rebuilt, although in some cases you may have to stop and
restart them (re-run `docker-compose up`).

The current compose file assumes that the docker machine/VM is accessible at 192.168.99.100. This
is true by default, but may not be true for you.

Limitations
-----------

- Pebble SSO is not available; only local accounts work.
- Websocket installs are not available because pebble SSO is not available
- You'll have to change things manually if 192.168.99.100 isn't right.

Credits:
A special thanks to https://www.reddit.com/r/pebble/comments/bza6yq/how_to_get_cloudpebble_working_on_a_local_computer/

If you want to try CloudPebble - you can check a free CloudPebble service http://dev.vsys.ml (it works as of September 26 2019)