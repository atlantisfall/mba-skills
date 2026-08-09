#!/usr/bin/env bash
# three_pages PDF 渲染：pandoc → HTML → Chrome 无头（零安装、CJK 支持）
# 用法: render_pdf.sh <input.md> <output.pdf> [title] [font-size-pt]
#   字号: 9.2 = 密度档（默认）, 9.6 = 标准档
# 兜底: 无 Chrome 时用 `npx md-to-pdf`（首跑会下载 Chromium ~170MB）
set -euo pipefail

IN="${1:?usage: render_pdf.sh <input.md> <output.pdf> [title] [font-size-pt]}"
OUT="${2:?usage: render_pdf.sh <input.md> <output.pdf> [title] [font-size-pt]}"
TITLE="${3:-$(basename "$IN" .md)}"
FONT="${4:-9.2}"

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CSS="$SKILL_DIR/references/render.css"

# macOS 的 mktemp -t 把随机串追加在模板末尾（而非替换 X），会导致文件扩展名不是 .html、
# Chrome 把它当纯文本渲染。因此先 mktemp 生成唯一前缀，再手动补 .html 后缀。
TMP_HEADER="$(mktemp /tmp/threepages-hdr.XXXXXX).html"
TMP_HTML="$(mktemp /tmp/threepages-doc.XXXXXX).html"
trap 'rm -f "${TMP_HEADER%.html}" "${TMP_HTML%.html}" "$TMP_HEADER" "$TMP_HTML"' EXIT

# 注入 <style> 并把默认字号替换为参数值
{
  echo "<style>"
  sed "s/font-size: 9.2pt/font-size: ${FONT}pt/" "$CSS"
  echo "</style>"
} > "$TMP_HEADER"

pandoc -s -f gfm -t html5 -H "$TMP_HEADER" --metadata title="$TITLE" "$IN" -o "$TMP_HTML"

CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
if [ ! -x "$CHROME" ]; then
  echo "未找到 Chrome，回退 npx md-to-pdf…" >&2
  npx --yes md-to-pdf --stylesheet "$CSS" "$IN" --output "$OUT"
  exit 0
fi

"$CHROME" --headless --disable-gpu --print-to-pdf="$OUT" --no-pdf-header-footer "$TMP_HTML"
echo "已生成: $OUT"
