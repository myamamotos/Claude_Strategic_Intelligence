# Strategic Intelligence Daily Workflow

## Objective
世界情勢・日本国内の重要情報を日次で収集・整理し、HTMLブリーフィングとして出力する。
戦略コンサルタント視点での「事実」「解釈」「示唆」の3層整理を基本とする。

## Scope
- World Affairs（世界情勢）
- Japan Domestic（日本国内）

## Folder Structure
```
Strategic_Intelligence/
├── 00_governance/     # ルール・テンプレート（このフォルダ）
├── 01_input/          # 収集した生データ（日付フォルダ別）
├── 02_analysis/       # 分析・整理済みデータ（日付フォルダ別）
├── 03_output/         # 最終HTML出力（日付フォルダ別）
└── 04_prompts/        # フェーズ別プロンプトテンプレート
```

## Daily Task Flow
1. **[手動 / チャット]** `04_prompts/p1_collect.md` を実行
   - Claudeチャットのweb searchで当日分を収集
   - `01_input/YYYY-MM-DD/` に world_raw.md / japan_raw.md を保存
2. **[自動 / Claude Code]** `run_daily.sh` を実行
   - p2_analyze: taxonomy準拠で分析・整理 → `02_analysis/YYYY-MM-DD/`
   - p3_generate_html: HTML生成 → `03_output/YYYY-MM-DD/`

## Output Rules
- 事実と解釈・示唆を必ず分けて記述する
- 一次情報を最優先とし、出所不明情報はHTMLに含めない
- confidence（A/B/C）を各アイテムに必ず付与する
- 断定表現を避け、根拠を明示する

## Prohibited
- 未確認情報・SNS由来の情報をHTMLに出力しない
- 一次情報なき憶測を「示唆」として記述しない
- ソース不明の数値・統計を使用しない

## Source Priority
source_policy セクション参照（下記）

## Source Policy
### 一次情報（confidence: A）
- 政府・省庁・首相官邸・官報
- 中央銀行（日銀・FRB・ECBなど）
- 国際機関（IMF・World Bank・BIS・WTO・UN）
- 企業IR・決算発表
- 統計当局（総務省統計局・US BLS等）

### 準一次情報（confidence: B）
- 大手通信社（Reuters, AP, Bloomberg, 共同通信）
- 主要全国紙（日本経済新聞、読売、朝日、Financial Times, WSJ）
- 主要経済紙・専門メディア（Nikkei Asia, The Economist）

### 補助情報（confidence: C）
- シンクタンク（RAND, Brookings, 野村総研, 日本総研等）
- 業界団体・経済団体発表
- 専門メディア（MIT Tech Review等）

### 除外（使用禁止）
- SNS（X, Facebook等）
- 個人ブログ・まとめサイト
- 未確認・速報のみで裏取りなし
