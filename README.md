# dotfiles
dotfiles

## requirements
- place 'sync' folder in Google Drive

## warning
- make sure authority to execute shell

## installed
- brew
- warp
- regolith(i3)
- rclone
- eww lockscreen config

## eww lockscreen requirements
- eww
- i3lock-color
- playerctl
- jq
- curl
- imagemagick
- khal
- JetBrains Mono or Iosevka / Nerd Font compatible font

For weather widgets, set these environment variables before starting eww:
```
export OPENWEATHER_API_KEY="your-api-key"
export OPENWEATHER_CITY_ID="your-city-id"
```

## eww lockscreen check
```
lockscreen-check
lockscreen-check daemon
lockscreen-check clock
lockscreen-check all
lockscreen-check lock
```

`lockscreen-check` verifies required commands, files, and helper scripts. The other modes run the same commands listed in `ToDO.md` Phase 5.

## after install
- need rclone setting
```
rclone config
```
1. n を入力（新しいリモートを作成）
2. 名前を入力（例：drive）
3. ストレージタイプで drive を選択
4. client_id と client_secret は空白のままEnter
5. scope は 1（フルアクセス）を選択
6. root_folder_id は空白のままEnter
7. service_account_file は空白のままEnter
8. 高度な設定は n（デフォルト）
9. 自動設定は y（デフォルト）
