# Rsync docker-compose.yml files

Rsync script to consolidate all docker-compose.yml files in a single directory \
and then push that directory to TrueNAS which has a task to sync with Google Cloud.

Execution status will be sent through Ntfy.

## Workflow
1. All docker-compose.yml files from all specified servers will be fetched.
2. All fetched files will be saved to a redundant filesystem.
3. All saved files will be pushed to a TrueNAS server.
4. All files will be backed up in Google Cloud.
4. Execution status will be sent through Ntfy

Notification example: <br/>
![Ntfy compose files backup](https://github.com/jlleonr/jlleonr/blob/main/assets/IMG_1983.jpeg)
