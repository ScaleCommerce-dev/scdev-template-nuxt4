# Scaffold Nuxt 4 project and install dependencies

[no-exit-message]
default:
    scdev start
    @echo ""
    @echo "Installing tools..."
    scdev exec app sh -c "corepack enable && apk add --no-cache git"
    @echo ""
    @echo "Scaffolding Nuxt project..."
    scdev exec app pnpm dlx nuxi@latest init . --packageManager pnpm --gitInit=false --force
    @echo ""
    @echo "Preparing Nuxt modules..."
    scdev exec app npx nuxi prepare
    @echo ""
    @echo "Approving native module builds..."
    scdev exec app pnpm approve-builds --all
    @echo ""
    @echo "Finalizing..."
    scdev exec app sh -c "echo '.setup-complete' >> .gitignore && touch .setup-complete"
    @echo ""
    @echo "Setup complete! App will start automatically."
    @echo ""
    @echo "Here are the details about your new project:"
    @echo ""
    scdev info
