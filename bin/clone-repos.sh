#!/usr/bin/env bash

set -euo pipefail

repositories=(
    "statamic/cms                      Statamic/cms"
    "statamic/cli                      Statamic/cli"
    "statamic/statamic                 Statamic/statamic"
    "statamic/audit-log                Statamic/audit-log"
    "statamic/collaboration            Statamic/collaboration"
    "statamic/eloquent-driver          Statamic/eloquent-driver"
    "statamic/forms-pro                Statamic/forms-pro"
    "statamic/importer                 Statamic/importer"
    "statamic/mailables-viewer         Statamic/mailables-viewer"
    "statamic/migrator                 Statamic/migrator"
    "statamic/podcast-categories       Statamic/podcast-categories"
    "statamic/seo-pro                  Statamic/seo-pro"
    "statamic/sidecar                  Statamic/sidecar"
    "statamic/ssg                      Statamic/ssg"
    "statamic/wikilinks                Statamic/wikilinks"
    "statamic-rad-pack/runway          Statamic/runway"
    "duncanmcclean/cookie-notice       SideProjects/cookie-notice"
    "duncanmcclean/guest-entries       SideProjects/guest-entries"
    "duncanmcclean/simple-commerce     SideProjects/simple-commerce"
    "duncanmcclean/statamic-cargo       SideProjects/statamic-cargo"
    "duncanmcclean/tether              SideProjects/tether"
)

for repository in "${repositories[@]}"; do
    read -r name path <<< "$repository"
    destination="$HOME/Code/$path"

    if [[ -d "$destination" ]]; then
        gum log --structured --level info "Skipping $name, already cloned" path "$destination"
        continue
    fi

    gum log --structured --level info "Cloning $name" path "$destination"

    if ! git clone "git@github.com:$name.git" "$destination"; then
        gum log --structured --level error "Failed to clone $name"
    fi
done

gum log --structured --level info "Done!"
