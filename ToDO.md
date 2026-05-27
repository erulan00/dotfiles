# EWW Lockscreen Clock ToDo

## Goal

EWW を使って待機画面・ロック画面に時計を安定表示する。まずは「時計だけが確実に出る」最小構成を作り、その後に天気・Spotify・カレンダーを戻す。

## Current Findings

### Critical

- [x] `lockscreen-clock.patch` が実ファイルへ適用されていない。
  - `lockscreen-clock.patch` には `clock` 定義、`LOCK_TIME` / `LOCK_DATE`、`open-many clock ...` がある。
  - しかし `.config/eww/lockscreen/eww.xml` には `clock` window が存在しない。
  - `.local/bin/i3lock-widgets` も `open-many player-spotify weather calendari` のままで、`clock` を開いていない。

- [x] EWW の script-var 参照パスが実体とずれている。
  - 現在: `~/.config/eww/scripts/...`
  - 実体: `~/.config/eww/lockscreen/scripts/...`
  - 対象: weather, getart, echoart, calendar 系。
  - このままだと EWW 起動時に script-var が失敗し、画面全体の不安定化につながる。

- [x] ロック画像のパスが存在しない。
  - `.local/bin/i3lock-widgets` は `images/fons-lock.png` を指定している。
  - リポジトリにある画像は `images/image.png` のみ。
  - `i3lock-color -i` が失敗してロック画面起動自体が止まる可能性がある。

### High

- [x] 時計表示の責任が `i3lock-color` と EWW で二重になりかけている。
  - 現状は `i3lock-color --clock` で時計を表示している。
  - 目標が「EWW で時計表示」なら、EWW の `clock` window を追加し、`i3lock-color` 側の `--time-str` / `--date-str` は空または最小化する。
  - ただし EWW がロック画面より前面に出るかは WM / compositor / i3lock の挙動に依存するため検証が必要。

- [x] `install.sh` に EWW ロック画面用の依存関係が不足している。
  - 少なくとも確認対象: `eww`, `i3lock-color`, `playerctl`, `jq`, `curl`, `imagemagick`, `khal`, Nerd Font / Iosevka。
  - この環境では `command -v eww` が空だったため、EWW が未導入の可能性が高い。

- [x] `stow` 対象に `.config/eww` と `.local/bin` が明示されていない。
  - `install.sh` は `stow i3` と `stow -v rclone` だけを実行している。
  - ロック画面設定を `$HOME` に展開する手順がないため、リポジトリ上で直しても実環境に反映されない可能性がある。

### Medium

- [x] 天気スクリプトが初回キャッシュ未生成に弱い。
  - `weather_info --icon` などはキャッシュファイルを `cat` するだけ。
  - `--getdata` を事前実行していない場合、ファイル未存在で失敗する。
  - `KEY` と `ID` が空のため、OpenWeatherMap 取得は常に失敗する見込み。

- [x] `weather_info` に typo がある。
  - エラー時に `echo "#adadff" > ${tcache_weather_hex}` となっている。
  - 正しくは `${cache_weather_hex}`。

- [x] `getart` のフォールバック画像パスがずれている。
  - 現在: `~/.config/eww/images/image.png`
  - 実体候補: `~/.config/eww/lockscreen/images/image.png`

- [x] 未存在スクリプトを script-var に登録している。
  - `getvol`, `getbri`, `~/bin/spotifystatus` がリポジトリ内にない。
  - 現状 UI 上ではコメントアウトされている値もあるが、script-var としては実行される。

- [x] script-var の更新間隔が短すぎる。
  - `volume` は `3ms`、`bright` は `1ms`。
  - ロック画面用途では負荷が高く、不要なら削除、必要でも `1s` 程度へ変更する。

## Improvement Map

### Phase 1: 時計だけを復旧する

- [x] `.config/eww/lockscreen/eww.xml` に `clock` definition を追加する。
- [x] `LOCK_TIME` と `LOCK_DATE` の script-var を追加する。
- [x] `clock` window を追加する。
- [x] `.config/eww/lockscreen/eww.scss` に `.clock_win`, `.clock_time`, `.clock_date` を追加する。
- [x] `.local/bin/i3lock-widgets` の `open-many` に `clock` を追加する。
- [x] `LOCK_IMG` に `images/image.png` fallback を入れる。
- [x] EWW 時計と競合しないよう、`i3lock-color` 側の時刻・日付表示を一時的に消す。

### Phase 2: EWW 設定のパスを整理する

- [x] `~/.config/eww/scripts/...` を `~/.config/eww/lockscreen/scripts/...` に統一する。
- [x] `getart` のフォールバック画像を `lockscreen/images/image.png` に修正する。
- [x] 存在しない `getvol`, `getbri`, `spotifystatus` の script-var を削除または実装する。
- [x] Spotify が起動していない時でも空文字で正常終了するようにする。

### Phase 3: 天気・カレンダーを壊れにくくする

- [x] `weather_info` の `${tcache_weather_hex}` typo を直す。
- [x] キャッシュ未生成時は `--getdata` を試す、またはデフォルト値を返す。
- [x] OpenWeatherMap の `KEY` / `ID` を直書きせず、環境変数や別ファイルで扱う。
- [x] `khal` がない場合やカレンダーが未設定の場合、空文字または固定メッセージで正常終了する。

### Phase 4: インストール手順を再現可能にする

- [x] `install.sh` の shebang を `#!/usr/bin/env bash` に直す。
- [x] `install.sh` に `set -euo pipefail` を追加する。
- [x] EWW ロック画面に必要な依存関係を README と install 手順に追加する。
- [x] `stow` 対象として `.config/eww` と `.local/bin` を扱える構成にする。
- [x] Ubuntu 用 install 手順と Arch / pacman 用 Warp 手順を分離する。

### Phase 5: 検証手順を固定する

- [x] `lockscreen-check` で依存関係・設定ファイル・補助スクリプトを確認できるようにする。
- [x] `lockscreen-check daemon` で `eww -c ~/.config/eww/lockscreen daemon` を起動できるようにする。
- [x] `lockscreen-check clock` で `eww -c ~/.config/eww/lockscreen open clock` を実行できるようにする。
- [x] `lockscreen-check all` で `eww -c ~/.config/eww/lockscreen open-many clock weather calendari player-spotify` を実行できるようにする。
- [x] `lockscreen-check lock` で `~/.local/bin/i3lock-widgets` を実行できるようにする。
- [x] `i3lock-widgets` 終了時に `eww -c ~/.config/eww/lockscreen close-all` が実行され、ウィンドウが残りにくいようにする。
- [ ] 実機で `lockscreen-check daemon` が起動することを確認する。
- [ ] 実機で `lockscreen-check clock` を実行し、時計だけ表示できることを確認する。
- [ ] 実機で `lockscreen-check all` を実行し、全ウィジェットを確認する。
- [ ] 実機で `lockscreen-check lock` を実行し、ロック中に時計が見えることを確認する。

Note: 2026-05-27 時点の作業環境では `eww` と `i3lock-color` が未導入だったため、Phase 5 の実機表示確認は未実施。`lockscreen-check` はその他の依存・設定ファイル・補助スクリプトが揃っていることを確認済み。

## Recommended First Patch

1. `lockscreen-clock.patch` の内容を実ファイルに反映する。
2. ただし `getvol`, `getbri`, `spotifystatus` は未存在なので、最初の復旧パッチでは削除またはコメントアウトする。
3. `LOCK_IMG` fallback を必ず入れる。
4. まず `clock` 単体で確認し、成功後に weather / Spotify / calendar を戻す。
