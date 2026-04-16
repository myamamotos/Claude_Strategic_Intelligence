# p1_collect: 情報収集プロンプト
# 実行場所: Claudeチャット（web search使用）
# 実行タイミング: 毎朝、p2実行前

---

以下のルールに従い、本日分の戦略インテリジェンス情報を収集してください。

## 収集ルール
- 対象期間: 過去24時間（重要案件は48時間まで補完）
- ソース優先順位: 一次情報 > 準一次情報 > 補助情報（SNS・個人ブログは除外）
- 重複ニュースは統合し、最も信頼度の高いソースを代表として使用
- 重要度が低い雑多情報は除外する

## 収集対象

### World Affairs（世界情勢）
以下のdomainで重要情報を収集:
- geopolitics（地政学・安全保障・紛争）
- macroeconomy（金利・為替・GDP・貿易）
- markets（株・債券・コモディティ）
- diplomacy（首脳外交・国際交渉・制裁）
- technology（AI・半導体・サイバー・規制）
- energy（資源・脱炭素・気候政策）
- supply_chain（サプライチェーン・関税）

### Japan Domestic（日本国内）
以下のdomainで重要情報を収集:
- politics（政権・国会・選挙動向）
- monetary_policy（日銀・金利・円）
- fiscal_policy（予算・税制・財政）
- industry（製造・小売・EC・DX）
- regulation（省庁・法改正・行政指導）
- labor（賃金・雇用・人口）
- regional（地方創生・地域経済）
- foreign_relations（外交政策）

## 出力フォーマット（1件ごと）
```
- title: （記事・発表のタイトル）
- date: （発表日時）
- source: （ソース名）
- source_type: primary / major_media / think_tank / other
- url: （URL）
- domain: （taxonomy.mdのdomain名）
- geography: world / japan
- raw_notes: （原文の要点を3〜5行で）
```

## 保存指示
収集結果を以下の2ファイルに分けて出力してください。
ファイルの内容をそのままコピーしてローカルに保存できる形式で出力すること。

- `01_input/YYYY-MM-DD/world_raw.md`（世界情勢分）
- `01_input/YYYY-MM-DD/japan_raw.md`（日本国内分）

※ YYYY-MM-DDは本日の日付に置き換える
