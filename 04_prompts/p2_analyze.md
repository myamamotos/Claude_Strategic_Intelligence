# p2_analyze: 分析・整理プロンプト
# 実行場所: Claude Code
# 実行タイミング: p1完了・raw.md保存後
# 参照ファイル: 00_governance/taxonomy.md

---

## 指示

`01_input/YYYY-MM-DD/` 配下の本日分データを読み込み、
`00_governance/taxonomy.md` の分類体系に従って分析・整理してください。

## 処理手順

1. `01_input/YYYY-MM-DD/world_raw.md` を読み込む
2. `01_input/YYYY-MM-DD/japan_raw.md` を読み込む
3. `00_governance/taxonomy.md` を読み込む
4. 各アイテムを下記フォーマットで整理する
5. `02_analysis/YYYY-MM-DD/` フォルダを作成して保存する

## 出力フォーマット（1件ごと）

```
- title:
- date:
- source:
- source_type: primary / major_media / think_tank / other
- geography: world / japan
- domain:（taxonomy.md準拠）
- impact: HIGH / MEDIUM / LOW
- horizon: immediate / short / medium
- summary_3lines:（3行以内で事実のみ）
- why_it_matters:（なぜ重要か・1〜2行）
- implications_1m:（1ヶ月視点の示唆・1〜2行）
- implications_3m:（3ヶ月視点の示唆・1〜2行）
- confidence: A / B / C
- citation_url:
```

## 整理の原則
- `summary_3lines` は事実のみ。解釈を混入しない
- `why_it_matters` と `implications` で初めて解釈・示唆を記述する
- `confidence` は source_type から判定（primary=A, major_media=B, think_tank/other=C）
- `impact: HIGH` は経営・政策判断に直結するものに限定する

## 保存先
- `02_analysis/YYYY-MM-DD/world_analyzed.md`
- `02_analysis/YYYY-MM-DD/japan_analyzed.md`

※ YYYY-MM-DDは処理対象の日付（01_inputの日付フォルダに合わせる）
