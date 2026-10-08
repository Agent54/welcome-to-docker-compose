# Welcome to Docker — Compose demo

A small static-site demo for the Darc catalog, based on Docker's official
[Welcome to Docker](https://github.com/docker/welcome-to-docker) `small-image`
branch at commit `6b1942e90345d65ca704540a4c4212d86a694513`. The upstream source
and Git history are preserved; this repository adds a standalone Compose file
and a non-root Nginx configuration.

## Run

```sh
docker compose up --build -d --wait
```

Open [http://localhost:8080](http://localhost:8080). Darc can launch this project
directly from `compose.yaml`; no generated Compose file or overlay is required.

Stop the demo:

```sh
docker compose down
```

## Container

Node builds the static files in a separate build stage. The runtime contains
only `nginx:alpine-slim` and the built site, running as the `nginx` user on port
8080. Compose drops all Linux capabilities, prevents privilege escalation,
uses a read-only filesystem with a 16 MiB temporary filesystem, and limits the
container to 64 MiB of memory, half a CPU, and 32 processes. It has no database,
host bind mounts, Docker socket access, or persistent volumes.

The build uses the committed npm lockfile and disables dependency install
scripts. Base images receive updates through their upstream tags. The GitHub
Actions smoke check builds this same Compose project, waits for its health
check, checks the served HTML and JavaScript, and verifies the runtime user
and filesystem restrictions.
