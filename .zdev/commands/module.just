# Manage Nuxt modules, forwarding to `nuxi module` INSIDE the container:
#
#   zdev module add @nuxt/image @nuxt/eslint   # add one or more (installs + edits nuxt.config)
#   zdev module remove @nuxt/image             # remove
#   zdev module search image                   # search the module registry
#
# Running in the container matters for `add`/`remove`: Nuxt is installed there,
# so it's version-aware and node_modules stays container-side (never on the host).
# `add` updates nuxt.config.ts + package.json — commit those two files. Flags pass
# through too, e.g. `zdev module add @nuxt/image --dev`.
#
# This replaces create-nuxt's create-time module picker, which couldn't run at
# scaffold time (Nuxt isn't installed yet, and its install is unreliable there).

[no-exit-message]
module *args:
    zdev exec app pnpm dlx nuxi@latest module {{args}}
