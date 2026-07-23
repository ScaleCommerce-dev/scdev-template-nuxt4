# Nuxt 4 dev image: Node 24 + zpinit as PID 1.
#
# Supervise mode (mode 3): there is NO CMD, so zpinit runs the scripts in
# .zdev/zpinit/entrypoint.d/ (dependency install) and then supervises the
# services in .zdev/zpinit/services/ (the dev server, services/10_app.toml).
#
# Why supervise instead of a plain CMD: if the dev server crashes (e.g.
# nuxt.config.ts references a module that isn't installed — the classic result
# of an interrupted `zdev module add`), zpinit stays PID 1 and the CONTAINER
# STAYS UP. That keeps `zdev exec` / `zdev module add` working so the project is
# recoverable in place, instead of a crashed CMD taking the whole container down.
#
# There is no scaffolding here and no `.setup-complete` gate: the project is
# generated once at `zdev create` time by .zdev/scaffold.sh (run in a throwaway
# container that bypasses this entrypoint), so by the time this image runs
# normally there is always a project to install and serve. See
# https://github.com/0ploy/zpinit
FROM node:24-alpine

# zpinit (PID 1) + zpctl (operator CLI: `zdev exec app zpctl status|restart app`,
# used to bring the dev server back after fixing a bad config in place).
COPY --from=ghcr.io/0ploy/zpinit:latest /usr/local/bin/zpinit /usr/local/bin/
COPY --from=ghcr.io/0ploy/zpinit:latest /usr/local/bin/zpctl  /usr/local/bin/

# git: the Nuxt scaffolder (giget) needs it to fetch the starter template.
# corepack: enable it AND bake a concrete pnpm into the image (corepack prepare
# --activate). Without the prepare step, corepack downloads pnpm on first use and
# — since the create-time scaffold container gets no config.yaml env, only the
# image's — prompts "Corepack is about to download …" with no way to answer.
# Baking it means pnpm is already present, so no download and no prompt.
RUN apk add --no-cache git \
 && corepack enable \
 && corepack prepare pnpm@latest --activate

# Belt-and-suspenders: even if corepack ever does fetch a pnpm (e.g. a project
# pins a different packageManager version), never block on the download prompt.
# Baked into the image so it applies to the scaffold container too (which gets no
# config.yaml environment).
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0

COPY .zdev/zpinit/ /etc/zpinit/

WORKDIR /app
# No CMD -> zpinit runs entrypoint.d/ then supervises services/ (mode 3).
ENTRYPOINT ["zpinit"]
