# kanaemi-mode

Vim / Neovim から、IME の Kanaemi のモード（`kana` か `abc`）を読み、変え、変わったことを知るプラグイン。

## 設定

Kanaemi の設定ファイルに、外からの操作を待つポートを書く。

```toml
[control]
port = 50123
```

同じポートをプラグインに教える。

```vim
let g:kanaemi_mode_port = 50123
```

## 関数

| 関数 | すること |
| --- | --- |
| `kanaemi_mode#get_mode()` | フォーカスのある入力欄のモードを返す |
| `kanaemi_mode#set_mode(mode)` | モードを `mode` にし、変えたあとのモードを返す |
| `kanaemi_mode#watch_mode({ mode -> ... })` | モードが変わるたびに呼ぶ。呼ぶとやめる関数を返す |

うまくいかないときは `kanaemi_mode: ` で始まる例外を投げる。詳しくは `:help kanaemi-mode` を見る。

```vim
" 挿入モードを抜けたら ABC にする
autocmd InsertLeave * silent! call kanaemi_mode#set_mode('abc')
```

## テスト

```sh
./tests/run.sh
```

Vim と Neovim のそれぞれで、Kanaemi の代わりのサーバー（Python 3）を相手に動かす。

## ライセンス

MIT
