#!/bin/sh
# Create-time scaffold hook. `zdev create` runs this ONCE, inside a throwaway
# container whose entrypoint is overridden to a shell — so zpinit and
# entrypoint.d/ (dependency install) do NOT run here. It generates the project
# source only; dependencies install on the first real boot (see
# zpinit/entrypoint.d/).
#
# Deliberately non-interactive. create-nuxt's module picker is coupled to its
# own `pnpm install`, which (a) writes node_modules into this one-time bind
# mount — i.e. onto the host, where it does not belong (node_modules is
# container-only, in mutagen.ignore) — and (b) is unreliable here: create-nuxt
# does not pass pnpm's --config.dangerouslyAllowAllBuilds, so pnpm v11 aborts
# with ERR_PNPM_IGNORED_BUILDS on native build scripts (esbuild). So we scaffold
# source only, with --no-install, and never install at create time.
#
# --template minimal keeps it deterministic; --packageManager / --gitInit=false
# suppress those prompts; --no-install keeps node_modules out of the bind mount
# (deps install at first boot into the persistent volume — see
# zpinit/entrypoint.d/10-install.sh).
#
# `< /dev/null`: zdev attaches a TTY to this hook (so scaffolders *can* prompt),
# but we don't want any prompts here — with a TTY, nuxi still asks "Would you
# like to browse and install modules?" despite --no-install. Feeding it
# /dev/null makes nuxi see a non-interactive stdin and take the flag-driven path.
# (Add modules after create with `zdev module add`.)
#
# Add Nuxt modules AFTER create with `zdev module add <name>` — it runs
# `nuxi module add` inside the container, where Nuxt is installed, so it is
# version-aware and keeps node_modules container-side. See .zdev/commands/module.just.
#
# After a successful `zdev create`, zdev renames this to scaffold.sh.disabled
# (kept for reference, never runs again). Delete it whenever you like.
set -eu

pnpm dlx nuxi@latest init . \
  --template minimal \
  --no-install \
  --packageManager pnpm \
  --gitInit=false \
  --force < /dev/null
