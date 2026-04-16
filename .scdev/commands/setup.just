# Scaffold Nuxt 4 project and install dependencies

[no-exit-message]
default:
    scdev start -q
    @scdev step "Installing tools"
    scdev exec app sh -c "corepack enable && apk add --no-cache git"
    @scdev step "Scaffolding Nuxt project"
    scdev exec app pnpm dlx nuxi@latest init . --packageManager pnpm --gitInit=false --force
    @scdev step "Preparing Nuxt modules"
    scdev exec app npx nuxi prepare
    @scdev step "Approving native module builds"
    scdev exec app pnpm approve-builds --all
    @scdev step "Finalizing"
    scdev exec app sh -c "echo '.setup-complete' >> .gitignore && touch .setup-complete"
    @scdev step "Setup complete! App will start automatically."
    scdev info
