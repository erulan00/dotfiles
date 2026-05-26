#!/bin/bash
# 同期先ディレクトリの作成
DEST="$HOME/GoogleDrive"
mkdir -p "$DEST"

# 同期実行
# --update: ローカルの方が新しい場合は上書きしない
# --verbose: ログを出す（systemdのログで確認可能）
rclone sync gdrive: "$DEST" \
    --include "/sync/**" \
    --update \
    --delete-excluded \
    --verbose \
    --config="$HOME/.config/rclone/rclone.conf"