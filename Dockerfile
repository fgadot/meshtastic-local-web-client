# Made by Frank Gadot 
# This Dockerfile builds the Meshtastic Local Web Client using Bun.
# It uses a multi-stage build to keep the final image small and efficient.
# The first stage clones the repository, installs dependencies, and builds the static site.
# The second stage serves the built site using Bun's preview server.
# meshtastic-local-web-client/Dockerfile
# Version: 1.0
# Base image: oven/bun:1.1
# License: MIT

# meshtastic-local-web-client/Dockerfile
################  Stage 1 — clone & build  ################
# Use Bun for building
FROM oven/bun:1.1 AS builder

# Install git **and** the CA bundle
RUN apt-get update && \
    apt-get install -y --no-install-recommends git ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Shallow-clone + fetch tags so git-describe works
RUN git clone --depth 20 --single-branch https://github.com/meshtastic/web.git /app \
 && git -C /app fetch --tags --depth 1

 WORKDIR /app

# remove the old v1 lockfile so Bun generates a fresh one
RUN rm -f bun.lock

# Install all dependencies for the monorepo
RUN bun install 

# Build the static site
WORKDIR /app/packages/web
RUN bun run build                      # produces dist/




################  Stage 2 — serve it  ################
FROM oven/bun:1.1

# add this block ↓ just once in the second stage
RUN apt-get update && \
    apt-get install -y --no-install-recommends git ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# 1- Copy the repo to /app
WORKDIR /app
COPY --from=builder /app /app

# 2- Then switch into the web package
WORKDIR /app/packages/web

EXPOSE 3000
CMD ["bun","x","vite","preview","--host","0.0.0.0","--port","3000"]
