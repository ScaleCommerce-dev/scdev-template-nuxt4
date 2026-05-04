# Scaffold Nuxt 4 project and install dependencies

[no-exit-message]
default:
    zdev start -q
    @zdev step "Installing tools"
    zdev exec app sh -c "corepack enable && apk add --no-cache git"
    @zdev step "Scaffolding Nuxt project"
    zdev exec app pnpm dlx nuxi@latest init . --packageManager pnpm --gitInit=false --force
    @zdev step "Preparing Nuxt modules"
    zdev exec app npx nuxi prepare
    @zdev step "Approving native module builds"
    zdev exec app pnpm approve-builds --all
    @zdev step "Finalizing"
    zdev exec app sh -c "echo '.setup-complete' >> .gitignore && touch .setup-complete"
    @zdev step "Setup complete! App will start automatically."
    zdev info
