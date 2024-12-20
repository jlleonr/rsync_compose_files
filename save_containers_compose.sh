#!/bin/bash
# Consolidate all docker-compose.yml files in a single directory and then
# push that directory to TrueNAS which has a task to sync with Google Cloud

## Options ##
# --dry-run
# -a = archive
# -r = recursive
# -t = preserve times
# -z = compress data during transfer
# -v = verbose


# Pull files from andromeda server
rsync -Partzv --include="docker-compose.yml" --exclude="/*/*" "$ANDROMEDA_COMPOSE_FILES_SRC" "$COMPOSE_FILES_DST"

# Pull files from bode server
rsync -Partzv -e "ssh -p 20" --include="docker-compose.yml" --exclude="/*/*" "$BODE_COMPOSE_FILES_SRC" "$COMPOSE_FILES_DST"

# Push files to TrueNAS server
rsync -Partzv -e "ssh -p 20" --include="docker-compose.yml" --exclude="/*/*" "${COMPOSE_FILES_DST}/" "$TRUENAS_SERVER_DST"

if [[ $? -eq 0 ]]; then
    # API call to ntfy
    curl --no-progress-meter \
    -X 'POST' \
    "$NTFY_SERVER_URL"'/compose_backups' \
    -H 'Authorization: Bearer '"$NTFY_API_KEY" \
    -H 'accept: */*' \
    -H 'Content-Type: application/json' \
    -H 'Title: Docker Compose Rsync Task' \
    -H 'Tags: floppy_disk, green_circle' \
    -d 'All docker-compose.yml files have been synced.'
else
    # Send error to ntfy
    curl --no-progress-meter \
    -X 'POST' \
    "$NTFY_SERVER_URL"'/compose_backups' \
    -H 'Authorization: Bearer '"$NTFY_API_KEY" \
    -H 'accept: */*' \
    -H 'Content-Type: application/json' \
    -H 'Title: Docker Compose Rsync Task' \
    -H 'Tags: floppy_disk, red_circle, rotating_light' \
    -d 'An error ocurred syncing the files.'
fi