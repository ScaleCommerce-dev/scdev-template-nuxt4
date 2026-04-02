# scdev Nuxt 4 Template

A starter template for [scdev](https://github.com/ScaleCommerce-DEV/scdev) that scaffolds a Nuxt 4 project with a working local development environment.

## What's included

- Node.js 22 (Alpine) container
- Nuxt 4 scaffolded via `nuxi init`
- pnpm as package manager
- HMR (Hot Module Replacement) via Nuxt dev server
- HTTPS via scdev's shared Traefik router
- Mutagen file sync (macOS) with node_modules and build artifacts kept inside the container

## Usage

```bash
scdev create nuxt4 my-app
cd my-app
scdev setup
```

After setup completes, your app is running at `https://my-app.scalecommerce.site`.

## What `scdev setup` does

1. Starts the Docker container (`scdev start`)
2. Enables pnpm via corepack
3. Scaffolds a fresh Nuxt 4 project via `nuxi init` (in a temp dir, then copies into the project)
4. Installs dependencies (`pnpm install`)
5. Marks setup as complete - the Nuxt dev server starts automatically

All commands can be seen in [.scdev/commands/setup.just](.scdev/commands/setup.just).

## Development

The Nuxt dev server runs with HMR - edit your components and see changes instantly in the browser.

To add packages:

```bash
scdev exec app pnpm add <package>
```

## Requirements

- [scdev](https://github.com/ScaleCommerce-DEV/scdev) installed
- Docker Desktop running

## Learn more

Want to create your own template? See the [Template Authoring Guide](https://github.com/ScaleCommerce-DEV/scdev/blob/main/templates/README.md).
