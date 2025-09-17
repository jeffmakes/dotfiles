#!/bin/bash
#set -x # Echo on

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root." >&2
  exit 1
fi

# Setting this, so the repo does not need to be given on the commandline:
export BORG_REPO=zh2956@ch-s012.rsync.net:mill-backup-repo
export BORG_REMOTE_PATH=/usr/local/bin/borg1/borg1 #for rsync.net
# Setting this, so you won't be asked for your repository passphrase:
export BORG_PASSPHRASE='imgettingtiredofthisorgasm'

# Call this once to set things up
notify_setup() {
    local sway_pid
    sway_pid=$(pgrep -u jeff -x sway)

    if [[ -z "$sway_pid" ]]; then
        echo "Error: Could not find sway process for user jeff."
        return 1
    fi

    export NOTIFY_DBUS_ADDRESS=$(cat /proc/"$sway_pid"/environ | tr '\0' '\n' | grep '^DBUS_SESSION_BUS_ADDRESS=' | cut -d= -f2-)
    
    if [[ -z "$NOTIFY_DBUS_ADDRESS" ]]; then
        echo "Error: Could not extract DBUS_SESSION_BUS_ADDRESS."
        return 1
    fi
}

# Call this any time you want to send a notification
notify() {
    local message="$*"

    if [[ -z "$NOTIFY_DBUS_ADDRESS" ]]; then
        echo "Error: NOTIFY_DBUS_ADDRESS not set. Did you run notify_setup?"
        return 1
    fi

    runuser -u jeff -- env DBUS_SESSION_BUS_ADDRESS="$NOTIFY_DBUS_ADDRESS" notify-send "$message"
}

notify_setup

# some helpers and error handling:
info() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

info "Starting backup"
notify "Starting backup"

# Backup the most important directories into an archive named after
# the machine this script is currently running on:

borg create                         \
     --progress \
     --verbose                       \
     --stats                         \
     --show-rc                       \
     --exclude-caches                \
     --compression lz4 \
     --exclude '/home/jeff/.ethereum'          \
     --exclude '/home/*/.cache/*'    \
     --exclude '/home/lost+found' \
     \
     ::'{hostname}-{now}'            \
     /home  \
     /root  \
     /etc   \
     /var   \
     /opt   \
     /usr/local   \
     /srv   
backup_exit=$?

info "Pruning repository"

# Use the `prune` subcommand to maintain 7 daily, 4 weekly and 6 monthly
# archives of THIS machine. The '{hostname}-' prefix is very important to
# limit prune's operation to this machine's archives and not apply to
# other machines' archives also:

borg prune                          \
    --list                          \
    --glob-archives='{hostname}-*'  \
    --show-rc                       \
    --keep-daily    7               \
    --keep-weekly   4               \
    --keep-monthly  6               \

prune_exit=$?

# use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))

if [ ${global_exit} -eq 1 ];
then
     info "Backup and/or Prune finished with a warning"
     notify "Backup and/or Prune finished with a warning"
fi

if [ ${global_exit} -gt 1 ];
then
     info "Backup and/or Prune finished with an error"
     notify "Backup and/or Prune finished with an error"
fi

if [ ${backup_exit} -eq 0 ];
then
     info "Backup finished successfully"
     notify "Backup finished successfully"
fi

exit ${global_exit}
