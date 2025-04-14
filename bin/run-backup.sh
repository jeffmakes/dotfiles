#!/bin/sh

# Setting this, so the repo does not need to be given on the commandline:
export BORG_REPO=zh2956@ch-s012.rsync.net:mill-backup-repo
export BORG_REMOTE_PATH=borg12 #for rsync.net
# Setting this, so you won't be asked for your repository passphrase:
export BORG_PASSPHRASE='imgettingtiredofthisorgasm'

# some helpers and error handling:
info() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

info "Starting backup"
notify-send "Starting backup"

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
     /etc   \
     /var   \
     /opt   \
     /srv   
backup_exit=$?

info "Pruning repository"

# Use the `prune` subcommand to maintain 7 daily, 4 weekly and 6 monthly
# archives of THIS machine. The '{hostname}-' prefix is very important to
# limit prune's operation to this machine's archives and not apply to
# other machines' archives also:

borg prune                          \
    --list                          \
    --prefix '{hostname}-'          \
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
     notify-send "Backup and/or Prune finished with a warning"
fi

if [ ${global_exit} -gt 1 ];
then
     info "Backup and/or Prune finished with an error"
     notify-send "Backup and/or Prune finished with an error"
fi

if [ ${backup_exit} -eq 0 ];
then
     info "Backup finished successfully"
     notify-send "Backup finished successfully"
fi

exit ${global_exit}
