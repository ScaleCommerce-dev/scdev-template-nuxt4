# zdev Nuxt 4 Template

A starter template for [zdev](https://github.com/0ploy/zdev) that scaffolds a Nuxt 4 project with a working local development environment.

## What's included

- Node.js 24 (Alpine) container
- [zpinit](https://github.com/0ploy/zpinit) as PID 1 — installs dependencies on boot, then supervises the dev server (so a crash keeps the container up and recoverable)
- Nuxt 4 scaffolded via `nuxi init` (latest 4.x, minimal template), once, at create time
- pnpm as package manager
- HMR (Hot Module Replacement) via Nuxt dev server
- HTTPS via zdev's shared Traefik router
- Mutagen file sync (macOS) with node_modules and build artifacts kept inside the container

## Usage

```bash
zdev create nuxt4 my-app
cd my-app
zdev start
```

`zdev create` scaffolds the project (see below); `zdev start` builds the image, installs
dependencies, and runs the dev server at `https://my-app.0ploy.dev`.

## How it works

**At create time**, `zdev create` runs the template's scaffold hook
([.zdev/scaffold.sh](.zdev/scaffold.sh)) once, inside a throwaway container, to generate a
fresh Nuxt 4 project (`nuxi init --template minimal`, no dependency install). After it
succeeds, zdev renames the hook to `.zdev/scaffold.sh.disabled` so it never runs again — you
can delete that file whenever you like.

**On every boot**, zpinit runs [.zdev/zpinit/entrypoint.d/10-install.sh](.zdev/zpinit/entrypoint.d/10-install.sh)
(`pnpm install`) and then **supervises** the Nuxt dev server ([.zdev/zpinit/services/10_app.toml](.zdev/zpinit/services/10_app.toml)).
Because install happens at boot, a teammate can **clone the project and just run `zdev start`** —
dependencies (and any pulled package changes) are installed automatically; no scaffolding re-runs.

The dev server runs as a *supervised service* (not the container's command), so if it crashes,
zpinit stays PID 1 and **the container stays up** — `zdev exec` keeps working and you can fix
things in place. See "Recovering a broken config" below.

## Recovering a broken config

The most common way to break the app is an interrupted `zdev module add`: `nuxi module add`
writes the module into `nuxt.config.ts` *before* it installs it, so if the install step fails
partway (a GitHub API rate limit, a network blip), you're left with a module referenced in
`nuxt.config.ts` but missing from `package.json`/`node_modules`. Nuxt then can't start:

```
ERROR  The module <name> could not be loaded. It may not be installed.
```

Because the dev server is supervised, the container **stays up** in this state (the `app`
service just crash-loops), so you can recover in place. Check what's wrong, then either:

```bash
zdev exec app zpctl status          # see the app service state (BACKOFF / FATAL)

# Option A — actually install the missing module (avoids the GitHub API entirely):
zdev exec app pnpm add <name>       # e.g. nuxt-auth-utils  (installs from npm)

# Option B — drop it from nuxt.config.ts (edit on the host), then reconverge.

zdev exec app zpctl restart app     # bring the dev server back (or `zdev restart`)
```

## Development

The Nuxt dev server runs with HMR — edit your components and see changes instantly in the browser.

### Nuxt modules

The scaffold is intentionally minimal. Manage official modules with `zdev module`, which
forwards to `nuxi module` inside the container:

```bash
zdev module add @nuxt/image @nuxt/eslint   # add one or more
zdev module remove @nuxt/image             # remove
zdev module search image                   # search the registry
```

`add`/`remove` run where Nuxt is installed, so they're version-aware and keep `node_modules`
container-side. `add` updates `nuxt.config.ts` + `package.json` — commit those two files.

### Add packages

```bash
zdev exec app pnpm add <package>
```

## Requirements

- [zdev](https://github.com/0ploy/zdev) installed
- Docker Desktop running

## Learn more

Want to create your own template? See the [Template Authoring Guide](https://github.com/0ploy/zdev/blob/main/templates/README.md).
