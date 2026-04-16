#!/bin/bash
# ============================================
# run_daily.sh
# 実行タイミング: p1（手動収集）完了後
# 実行方法: ./run_daily.sh
# ============================================

DATE=$(date +%Y-%m-%d)
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=============================="
echo " Strategic Intelligence Daily"
echo " 対象日付: $DATE"
echo "=============================="

# 01_input の当日フォルダ確認
INPUT_DIR="$BASE_DIR/01_input/$DATE"
if [ ! -d "$INPUT_DIR" ]; then
  echo ""
  echo "❌ エラー: $INPUT_DIR が見つかりません"
  echo "   先に p1_collect.md を実行して"
  echo "   world_raw.md / japan_raw.md を保存してください"
  exit 1
fi

if [ ! -f "$INPUT_DIR/world_raw.md" ] || [ ! -f "$INPUT_DIR/japan_raw.md" ]; then
  echo ""
  echo "❌ エラー: world_raw.md または japan_raw.md が存在しません"
  echo "   01_input/$DATE/ を確認してください"
  exit 1
fi

echo ""
echo "✅ 入力ファイル確認OK"
echo "   - $INPUT_DIR/world_raw.md"
echo "   - $INPUT_DIR/japan_raw.md"
echo ""

# 02_analysis フォルダ作成
mkdir -p "$BASE_DIR/02_analysis/$DATE"
# 03_output フォルダ作成
mkdir -p "$BASE_DIR/03_output/$DATE"

echo "-------------------------------"
echo "▶ Phase 2: 分析・整理 開始"
echo "-------------------------------"

claude --print "
00_governance/README.md を読み、運用ルールを把握してください。
次に 04_prompts/p2_analyze.md を読み、指示に従い
01_input/$DATE/world_raw.md と 01_input/$DATE/japan_raw.md を
00_governance/taxonomy.md の分類体系で分析してください。
結果を 02_analysis/$DATE/world_analyzed.md と
02_analysis/$DATE/japan_analyzed.md に保存してください。
作業ディレクトリは $BASE_DIR です。
"

echo ""
echo "-------------------------------"
echo "▶ Phase 3: HTML生成 開始"
echo "-------------------------------"

claude --print "
04_prompts/p3_generate_html.md を読み、指示に従い
02_analysis/$DATE/world_analyzed.md と
02_analysis/$DATE/japan_analyzed.md をもとに
00_governance/html_template.html のテンプレートでHTMLを生成してください。
03_output/$DATE/world_$( echo $DATE | tr -d '-').html と
03_output/$DATE/japan_$( echo $DATE | tr -d '-').html に保存してください。
作業ディレクトリは $BASE_DIR です。
"

echo ""
echo "=============================="
echo "✅ 完了"
echo "   出力先: 03_output/$DATE/"
echo "=============================="

# iCloud同期先へコピー（iCloudが存在する場合のみ）
ICLOUD_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Strategic_Intelligence/03_output/$DATE"
if [ -d "$HOME/Library/Mobile Documents/com~apple~CloudDocs" ]; then
  mkdir -p "$ICLOUD_DIR"
  cp "$BASE_DIR/03_output/$DATE/"*.html "$ICLOUD_DIR/" 2>/dev/null
  echo "   iCloud同期: $ICLOUD_DIR"
fi
