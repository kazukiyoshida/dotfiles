# Ghostty vs tmux 検討メモ (2026-03)

## 結論

**tmux を残す。** Ghostty の画面分割機能だけでは tmux を置き換えられない。

## 背景

Ghostty にも画面分割・タブ機能があるため、tmux が不要になるか検討した。

## 比較

| 機能 | Ghostty | tmux |
|------|---------|------|
| 画面分割 | あり | あり |
| タブ | あり | あり (window) |
| セッションのデタッチ/復帰 | 不可 | 可能 |
| SSH切断時のセッション維持 | 不可 | 可能 |
| vim操作でのコピー (copy-mode) | **なし** | あり |
| キーボードだけでスクロールバックからコピー | **なし** | あり |
| ウィンドウ状態の再起動復元 | あり | なし (プラグインで対応) |

## tmux を残す理由

1. **copy-mode** — `C-q Space` → vim キーバインドでスクロールバック内を移動・選択・コピーできる。Ghostty には同等機能がない ([Feature Request で議論中](https://github.com/ghostty-org/ghostty/discussions/3488) だが未実装)
2. **セッション永続化** — SSH接続が切れてもセッションが残る。ローカル作業でもターミナルを閉じてしまった場合に復帰できる

## 参考

- [Replacing tmux with Ghostty](https://sterba.dev/posts/replacing-tmux/) — ローカルのみの開発者による移行事例
- [Ghostty Panes vs tmux Panes](https://samuellawrentz.com/blog/ghostty-panes-vs-tmux/) — 比較記事
- [Ghostty + tmux 併用](https://samuellawrentz.com/blog/ghostty-tmux-productivity/) — 両方使うパターン
- [Ghostty copy-mode Feature Request](https://github.com/ghostty-org/ghostty/discussions/3488)
- [Ghostty vim navigation Feature Request](https://github.com/ghostty-org/ghostty/discussions/3708)
