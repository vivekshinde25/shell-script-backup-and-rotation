#!/bin/bash

<< readme
Backup Script with 5-Day Rotation

Usage:
./backup.sh <source_dir> <backup_dir>
readme

# ==============================
# Validate arguments
# ==============================
if [ $# -ne 2 ]; then
    echo "Usage: ./backup.sh <source_dir> <backup_dir>"
    exit 1
fi

# ==============================
# Variables
# ==============================
source_dir=$1
backup_dir=$2
timestamp=$(date '+%Y-%m-%d-%H-%M-%S')

# ==============================
# Check source directory
# ==============================
if [ ! -d "$source_dir" ]; then
    echo "❌ Source directory does not exist!"
    exit 1
fi

# ==============================
# Create backup directory
# ==============================
mkdir -p "$backup_dir"

# ==============================
# Backup Function
# ==============================
create_backup() {
    echo "📦 Creating backup..."

    if command -v zip &> /dev/null; then
        zip -r "${backup_dir}/backup_${timestamp}.zip" "$source_dir" > /dev/null
    else
        echo "⚠️ zip not found, using tar instead"
        tar -czf "${backup_dir}/backup_${timestamp}.tar.gz" "$source_dir"
    fi

    if [ $? -eq 0 ]; then
        echo "✅ Backup created: backup_${timestamp}"
    else
        echo "❌ Backup failed!"
        exit 1
    fi
}

# ==============================
# Rotation Function (keep 5 latest)
# ==============================
perform_rotation() {
    echo "🔄 Checking for old backups..."

    backups=($(ls -t ${backup_dir}/backup_* 2>/dev/null))

    if [ ${#backups[@]} -gt 5 ]; then
        echo "🧹 Removing old backups..."

        backups_to_delete=("${backups[@]:5}")

        for file in "${backups_to_delete[@]}"; do
            rm -f "$file"
            echo "🗑️ Removed: $file"
        done
    else
        echo "✅ No old backups to remove"
    fi
}

# ==============================
# Execute
# ==============================
create_backup
perform_rotation
