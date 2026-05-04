# zdev Nuxt 4 Template

A starter template for [zdev](https://github.com/0ploy/zdev) that scaffolds a Nuxt 4 project with a working local development environment.

## What's included

- Node.js 22 (Alpine) container
- Nuxt 4 scaffolded via `nuxi init`
- pnpm as package manager
- HMR (Hot Module Replacement) via Nuxt dev server
- HTTPS via zdev's shared Traefik router
- Mutagen file sync (macOS) with node_modules and build artifacts kept inside the container

## Usage

```bash
zdev create nuxt4 my-app
cd my-app
zdev setup
```

After setup completes, your app is running at `https://my-app.0ploy.dev`.

## What `zdev setup` does

1. Starts the Docker container (`zdev start`)
2. Enables pnpm via corepack
3. Scaffolds a fresh Nuxt 4 project via `nuxi init` (in a temp dir, then copies into the project)
4. Installs dependencies (`pnpm install`)
5. Marks setup as complete - the Nuxt dev server starts automatically

All commands can be seen in [.zdev/commands/setup.just](.zdev/commands/setup.just).

## Development

The Nuxt dev server runs with HMR - edit your components and see changes instantly in the browser.

To add packages:

```bash
zdev exec app pnpm add <package>
```

## Requirements

- [zdev](https://github.com/0ploy/zdev) installed
- Docker Desktop running

## Learn more

Want to create your own template? See the [Template Authoring Guide](https://github.com/0ploy/zdev/blob/main/templates/README.md).
