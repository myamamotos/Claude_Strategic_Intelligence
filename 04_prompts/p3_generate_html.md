# p3_generate_html: HTML生成プロンプト
# 実行場所: Claude Code
# 実行タイミング: p2完了・analyzed.md保存後
# 参照ファイル: 00_governance/html_template.html

---

## 指示

`02_analysis/YYYY-MM-DD/` の分析済みデータと
`00_governance/html_template.html` のテンプレートをもとに、
HTMLブリーフィングを2ファイル生成してください。

## 処理手順

1. `02_analysis/YYYY-MM-DD/world_analyzed.md` を読み込む
2. `02_analysis/YYYY-MM-DD/japan_analyzed.md` を読み込む
3. `00_governance/html_template.html` を読み込む
4. 下記仕様に従いHTML2本を生成する
5. `03_output/YYYY-MM-DD/` フォルダを作成して保存する

## HTML仕様

### ヘッダー部
- REPORT_TITLE: "World Affairs Brief YYYY-MM-DD" または "Japan Domestic Brief YYYY-MM-DD"
- DATE: 対象日付
- GENERATED_AT: 生成時刻（HH:MM JST）
- COVERAGE_WINDOW: "過去24時間"（または実際の対象期間）

### Executive Summary
- 全体を3〜5行で要約
- 最重要トピック2〜3件を必ず言及
- 事実ベースで記述し、冒頭に「本日の主要ポイント:」と入れる

### セクション構成
- taxonomy.mdのdomain順にセクションを並べる
- 該当アイテムがないdomainはスキップする
- 各カードに以下を表示:
  - タイトル
  - impactバッジ（HIGH/MEDIUM/LOW）
  - confidenceバッジ（A/B/C）
  - summary（3行要約）
  - implications（1ヶ月・3ヶ月）
  - ソース名とURL

### Implications for Business / Policy
- 当日の情報全体を俯瞰した戦略的示唆
- ビジネス視点と政策視点を分けて記述
- 3〜5行程度

## バッジのCSSクラス対応
- impact HIGH → `badge badge-high`
- impact MEDIUM → `badge badge-medium`
- impact LOW → `badge badge-low`
- confidence A → `badge badge-a`
- confidence B → `badge badge-b`
- confidence C → `badge badge-c`

## 保存先
- `03_output/YYYY-MM-DD/world_YYYYMMDD.html`
- `03_output/YYYY-MM-DD/japan_YYYYMMDD.html`

※ YYYY-MM-DDは処理対象の日付
