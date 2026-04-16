# Taxonomy: 分類体系

分析フェーズでは必ずこの分類に従って整理すること。
分類に迷う場合は最も近いdomainを選び、`domain_note`に補足を入れる。

---

## World Affairs（世界情勢）

| domain | 対象範囲 |
|--------|----------|
| `geopolitics` | 地政学リスク・安全保障・軍事・領土・紛争 |
| `macroeconomy` | 金利・為替・インフレ・GDP・貿易統計 |
| `markets` | 株式・債券・コモディティ・仮想資産 |
| `diplomacy` | 首脳外交・多国間交渉・国際条約・制裁 |
| `technology` | AI・半導体・サイバー・宇宙・規制 |
| `energy` | 資源・石油・LNG・脱炭素・気候政策 |
| `supply_chain` | サプライチェーン・物流・関税・貿易規制 |

---

## Japan Domestic（日本国内）

| domain | 対象範囲 |
|--------|----------|
| `politics` | 政権・与野党・選挙・内閣・国会 |
| `monetary_policy` | 日銀・金利・円・量的緩和 |
| `fiscal_policy` | 予算・税制・国債・財政健全化 |
| `industry` | 製造・小売・EC・DX・スタートアップ |
| `regulation` | 省庁動向・法改正・行政指導・ガイドライン |
| `labor` | 賃金・雇用・人口・働き方改革 |
| `regional` | 地方創生・地域経済・移住・地方行政 |
| `foreign_relations` | 対米・対中・対韓・外交政策 |

---

## 重要度スコアリング（scoring_rules）

### confidence（情報の確からしさ）
- `A`：一次情報に基づく（政府・中銀・IR等）
- `B`：準一次情報（大手通信社・主要全国紙）
- `C`：補助情報（シンクタンク・業界団体）

### impact（戦略的重要度）
- `HIGH`：経営・政策判断に直結する可能性が高い
- `MEDIUM`：中期的に影響が出る可能性がある
- `LOW`：参考情報・背景知識として有用

### horizon（時間軸）
- `immediate`：今週〜1ヶ月以内に影響
- `short`：1〜3ヶ月
- `medium`：3〜12ヶ月
