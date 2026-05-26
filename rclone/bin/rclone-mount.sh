#!/bin/bash
# マウントポイントの作成（なければ）
mkdir -p $HOME/GoogleDrive

# すでにマウントされている場合は一度解除（二重起動防止）
fusermount -u $HOME/GoogleDrive 2>/dev/null

# マウント実行
# --daemonフラグはsystemdで管理する場合、付けない方が制御しやすいです
rclone mount drive: $HOME/GoogleDrive \
    --vfs-cache-mode writes \
    --config=$HOME/.config/rclone/rclone.conf