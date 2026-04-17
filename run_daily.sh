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

# -----------------------------------------------
# index.html 再生成（03_output/ を走査）
# -----------------------------------------------
echo ""
echo "-------------------------------"
echo "▶ index.html 再生成"
echo "-------------------------------"

cd "$BASE_DIR"

python3 - "$BASE_DIR" << 'PYEOF'
import sys, os, glob, re

base = sys.argv[1]
out_root = os.path.join(base, "03_output")

# ファイル名→メタ情報
FILE_META = {
    "world":     {"label": "World Affairs",      "heading": "World Affairs Brief",      "tag": "world"},
    "japan":     {"label": "Japan Domestic",      "heading": "Japan Domestic Brief",      "tag": "japan"},
    "ai_market": {"label": "AI Market",           "heading": "AI Market Intelligence",    "tag": "ai"},
    "ec_market": {"label": "EC Market",           "heading": "EC Market Intelligence",    "tag": "ec"},
}

def meta_of(filename):
    for key, m in FILE_META.items():
        if filename.startswith(key + "_"):
            return m
    return {"label": filename, "heading": filename, "tag": "world"}

# 日付フォルダを降順で収集
dates = sorted(
    [d for d in os.listdir(out_root) if re.match(r'^\d{4}-\d{2}-\d{2}$', d)
     and os.path.isdir(os.path.join(out_root, d))],
    reverse=True
)

if not dates:
    print("  ⚠️  03_output/ に日付フォルダが見つかりません")
    sys.exit(0)

CSS = """
    :root {
      --bg: #0f1117; --surface: #1a1d27; --border: #2a2d3a;
      --text: #e8eaf0; --text-muted: #8b8fa8; --accent: #4f8ef7;
    }
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Hiragino Sans", "Yu Gothic UI", sans-serif;
      background: var(--bg); color: var(--text); line-height: 1.7;
      padding: 32px 16px; max-width: 900px; margin: 0 auto;
    }
    header { border-bottom: 1px solid var(--border); padding-bottom: 20px; margin-bottom: 32px; }
    header h1 { font-size: 1.6rem; font-weight: 700; margin-bottom: 6px; }
    header p { font-size: 0.88rem; color: var(--text-muted); }
    h2 {
      font-size: 0.78rem; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase;
      color: var(--text-muted); margin: 32px 0 14px; padding-bottom: 6px;
      border-bottom: 1px solid var(--border);
    }
    .card-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 12px; margin-bottom: 8px; }
    .brief-card {
      background: var(--surface); border: 1px solid var(--border); border-radius: 10px;
      padding: 16px 18px; text-decoration: none; color: var(--text);
      transition: border-color 0.15s, background 0.15s;
      display: flex; flex-direction: column; gap: 6px;
    }
    .brief-card:hover { border-color: var(--accent); background: #1e2233; }
    .brief-card .label { font-size: 0.7rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.08em; color: var(--accent); }
    .brief-card .title { font-size: 0.93rem; font-weight: 600; }
    .brief-card .date-tag { font-size: 0.78rem; color: var(--text-muted); }
    .archive-group { margin-bottom: 24px; }
    .archive-date { font-size: 0.85rem; font-weight: 700; color: var(--text-muted); margin-bottom: 8px; }
    .archive-links { display: flex; flex-wrap: wrap; gap: 8px; }
    .archive-link {
      background: var(--surface); border: 1px solid var(--border); border-radius: 6px;
      padding: 5px 14px; font-size: 0.82rem; text-decoration: none; color: var(--text);
      transition: border-color 0.15s;
    }
    .archive-link:hover { border-color: var(--accent); color: var(--accent); }
    .tag-world  { border-left: 3px solid #4f8ef7; }
    .tag-japan  { border-left: 3px solid #68d391; }
    .tag-ai     { border-left: 3px solid #a78bfa; }
    .tag-ec     { border-left: 3px solid #f6ad55; }
    footer { margin-top: 48px; padding-top: 16px; border-top: 1px solid var(--border); font-size: 0.78rem; color: var(--text-muted); }
"""

lines = []
lines.append('<!DOCTYPE html>')
lines.append('<html lang="ja">')
lines.append('<head>')
lines.append('  <meta charset="UTF-8" />')
lines.append('  <meta name="viewport" content="width=device-width, initial-scale=1.0" />')
lines.append('  <title>Strategic Intelligence Daily</title>')
lines.append(f'  <style>{CSS}  </style>')
lines.append('</head>')
lines.append('<body>')
lines.append('<header>')
lines.append('  <h1>Strategic Intelligence Daily</h1>')
lines.append('  <p>世界情勢・日本国内・AI市場・EC市場の日次ブリーフィング</p>')
lines.append('</header>')

# 表示順を定義（既知キーを優先、それ以外はファイル名順）
KEY_ORDER = ["world", "japan", "ai_market", "ec_market"]

def sort_key(fname):
    for i, k in enumerate(KEY_ORDER):
        if fname.startswith(k + "_"):
            return i
    return len(KEY_ORDER)

latest = dates[0]
latest_files = sorted(
    [os.path.basename(p) for p in glob.glob(os.path.join(out_root, latest, "*.html"))],
    key=sort_key
)

lines.append(f'<h2>Latest &mdash; {latest}</h2>')
lines.append('<div class="card-grid">')
for fname in latest_files:
    m = meta_of(fname)
    href = f"03_output/{latest}/{fname}"
    lines.append(f'  <a class="brief-card tag-{m["tag"]}" href="{href}">')
    lines.append(f'    <span class="label">{m["label"]}</span>')
    lines.append(f'    <span class="title">{m["heading"]}</span>')
    lines.append(f'    <span class="date-tag">{latest}</span>')
    lines.append(f'  </a>')
lines.append('</div>')

archive = dates[1:]
if archive:
    lines.append('<h2>Archive</h2>')
    for d in archive:
        files = sorted(
            [os.path.basename(p) for p in glob.glob(os.path.join(out_root, d, "*.html"))],
            key=sort_key
        )
        lines.append('<div class="archive-group">')
        lines.append(f'  <div class="archive-date">{d}</div>')
        lines.append('  <div class="archive-links">')
        for fname in files:
            m = meta_of(fname)
            href = f"03_output/{d}/{fname}"
            lines.append(f'    <a class="archive-link tag-{m["tag"]}" href="{href}">{m["label"]}</a>')
        lines.append('  </div>')
        lines.append('</div>')

lines.append('<footer>')
lines.append('  Generated by Strategic Intelligence Daily Workflow')
lines.append('</footer>')
lines.append('</body>')
lines.append('</html>')

with open(os.path.join(base, "index.html"), "w", encoding="utf-8") as f:
    f.write("\n".join(lines) + "\n")

print(f"  ✅ index.html を更新しました（最新: {latest}、日付数: {len(dates)}）")
PYEOF

# -----------------------------------------------
# Git: 03_output をコミットしてリモートへプッシュ
# -----------------------------------------------
echo ""
echo "-------------------------------"
echo "▶ Git: commit & push 開始"
echo "-------------------------------"

cd "$BASE_DIR"

# ユーザー設定確認
GIT_USER=$(git config user.name 2>/dev/null)
GIT_EMAIL=$(git config user.email 2>/dev/null)
if [ -z "$GIT_USER" ] || [ -z "$GIT_EMAIL" ]; then
  echo "❌ git user.name / user.email が未設定です"
  echo "   git config --global user.name  'Your Name'"
  echo "   git config --global user.email 'you@example.com'"
  exit 1
fi

# ステージング
git add 03_output/ index.html

# 差分がなければスキップ
if git diff --cached --quiet; then
  echo "ℹ️  コミット対象の変更がありません（スキップ）"
else
  git commit -m "Daily brief $DATE"
  if git push; then
    echo "✅ Git push 完了 → origin/main"
  else
    echo "❌ Git push に失敗しました"
    echo "   認証・ネットワーク設定を確認してください"
    exit 1
  fi
fi
