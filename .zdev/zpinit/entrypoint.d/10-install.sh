#!/bin/sh
# zpinit entrypoint.d step — runs on every boot, before the dev server (CMD).
#
# Installs dependencies at boot (not at scaffold time) so every start converges
# on package.json: a fresh clone with no node_modules, a pulled dependency
# change, or a new machine all Just Work via `zdev start`, with no re-scaffold.
# `pnpm install` also triggers Nuxt's postinstall (`nuxi prepare`).
#
# The wait: with the Dockerfile/ENTRYPOINT approach we bypass zdev's automatic
# `command:` sync gate, so we wait for zdev's Mutagen initial-sync marker here —
# otherwise install could race the sync and not see package.json yet. zdev
# touches /.zdev-sync-ready after the first flush. This runs inside
# entrypoint_script_timeout (default 5m); bump it in zpinit.toml if a cold
# install ever needs longer.
set -eu
cd /app

while [ ! -f /.zdev-sync-ready ]; do sleep 0.2; done

# Native build scripts (esbuild, sharp, ...) are auto-approved project-wide via
# pnpm-workspace.yaml (dangerouslyAllowAllBuilds). Without that, pnpm blocks them
# and, in this non-TTY boot path, aborts with ERR_PNPM_IGNORED_BUILDS — failing
# this script. One setting there covers this install and every other pnpm call
# (zdev module, manual pnpm add), so no per-command flag is needed here.
pnpm install
