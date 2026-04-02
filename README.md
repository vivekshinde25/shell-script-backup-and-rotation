# Backup & Rotation Script (Bash)

This is a simple bash script to take backup of a folder and keep only last 5 backups.

I also used cron to automate it.

---

## What it does

* Takes backup of a folder
* Adds timestamp to backup file
* Stores it in backup folder
* Deletes old backups (keeps only 5)
* Can run automatically using cron

---

## How to run

```bash
chmod +x backup.sh
./backup.sh <source_folder> <backup_folder>
```

Example:

```bash
./backup.sh data backups
```

---

## Cron job (automation)

I used this cron command:

```bash
* * * * * bash /home/ubuntu/shell-script-backup-and-rotation/backup.sh /home/ubuntu/shell-script-backup-and-rotation/data /home/ubuntu/shell-script-backup-and-rotation/backup
```

This runs the script every minute.

---

## backup.sh

```bash
#!/bin/bash

# checking arguments
if [ $# -ne 2 ]; then
    echo "give source and backup folder"
    exit 1
fi

source=$1
backup=$2
time=$(date '+%Y-%m-%d-%H-%M-%S')

# check source exists
if [ ! -d "$source" ]; then
    echo "source folder not found"
    exit 1
fi

# create backup folder if not present
mkdir -p "$backup"

echo "creating backup..."

# use zip if available else tar
if command -v zip > /dev/null; then
    zip -r "$backup/backup_$time.zip" "$source" > /dev/null
else
    tar -czf "$backup/backup_$time.tar.gz" "$source"
fi

# check success
if [ $? -ne 0 ]; then
    echo "backup failed"
    exit 1
fi

echo "backup done"

# rotation logic (keep 5)
files=($(ls -t $backup/backup_* 2>/dev/null))

if [ ${#files[@]} -gt 5 ]; then
    old_files=("${files[@]:5}")

    for f in "${old_files[@]}"; do
        rm -f "$f"
        echo "deleted $f"
    done
fi
```

---

## Notes

* Works on linux/mac
* zip is optional (uses tar if not installed)
* simple script for learning + practice

---

## Author

Your Name

