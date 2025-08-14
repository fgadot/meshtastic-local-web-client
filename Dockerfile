# ---------- Stage 1: build ----------
FROM node:20-bullseye-slim AS builder

# Tools needed to clone & verify TLS
RUN apt-get update && apt-get install -y --no-install-recommends \
    git ca-certificates && rm -rf /var/lib/apt/lists/*

# Enable pnpm via Corepack (ships with Node >=16.13)
RUN corepack enable && corepack prepare pnpm@9.12.3 --activate

# Clone repo (shallow + tags for git-describe)
RUN git clone --depth 20 --single-branch https://github.com/meshtastic/web.git /app \
 && git -C /app fetch --tags --depth 1

WORKDIR /app

# Install workspace deps with pnpm (respects preinstall hook)
RUN pnpm install --frozen-lockfile

# Build the web package
WORKDIR /app/packages/web
RUN pnpm build  # produces dist/

# ---------- Stage 2: serve ----------
FROM nginx:alpine

# Copy built static files into nginx web root
COPY --from=builder /app/packages/web/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
