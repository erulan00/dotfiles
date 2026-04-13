# dotfiles
dotfiles

## warning
- make sure authority to execute shell

## installed
- brew
- warp
- regolith(i3)
- rclone

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