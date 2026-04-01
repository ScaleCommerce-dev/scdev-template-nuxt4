# Scaffold Nuxt 4 project and install dependencies

[no-exit-message]
default:
    scdev start
    scdev exec app sh -c "export COREPACK_ENABLE_DOWNLOAD_PROMPT=0 && corepack enable && apk add --no-cache git && pnpm dlx nuxi@latest init /tmp/app --packageManager pnpm --gitInit=false && rm -rf /tmp/app/node_modules /tmp/app/.git && cp -r /tmp/app/. /app/ && rm -rf /tmp/app && node -e \"var p=require('./package.json');p.pnpm={onlyBuiltDependencies:['better-sqlite3','esbuild']};require('fs').writeFileSync('package.json',JSON.stringify(p,null,2)+'\n')\" && pnpm install && touch .setup-complete"
    @echo ""
    @echo "Setup complete! App will start automatically."
    @echo ""
    @echo "Here are the details about your new project:"
    @echo ""
    scdev info
