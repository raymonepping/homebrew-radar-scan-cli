safe_name() {
  local name="$1"
  name="${name//\//_}"
  name="${name//:/_}"
  name="${name// /_}"
  echo "$name"
}

render_markdown_report() {
  local json_file="$1"
  local md_file="$2"
  local template="$3"
  local scan_time scan_type

  [[ ! -f "$template" ]] && { echo "⚠️  Markdown template not found: $template" >&2; return 1; }
  [[ ! -f "$json_file" ]] && { echo "⚠️  JSON findings file not found: $json_file" >&2; return 1; }

  scan_time="$(date '+%Y-%m-%d %H:%M:%S')"
  scan_type="${TYPE:-unknown}"

  findings_table_file=$(mktemp)
  jq -r -s '
    def row:
      "| \(.category // "-") | \(.path // "-") | \((.line_number // .metadata.start_line // .line // "-")) | \(.textual_context // "-") |";
    def header: "| Category | Path | Line | Context |\n|---|---|---|---|";
    if length == 0 or (.[0] | type == "null") then
      "| No findings | | | |"
    else
      header + "\n" + (map(row) | join("\n"))
    end
  ' "$json_file" > "$findings_table_file"

  sed -e "s|{{SCAN_TIMESTAMP}}|$scan_time|g" \
      -e "s|{{SCAN_TYPE}}|$scan_type|g" \
      "$template" | \
  awk -v table_file="$findings_table_file" '
    /{{FINDINGS_TABLE}}/ {
      while ((getline line < table_file) > 0) print line
      next
    }
    {print}
  ' > "$md_file"
  rm -f "$findings_table_file"
}

do_csv_findings() {
  local file="$1"
  [[ -s "$file" && $(wc -l <"$file") -gt 1 ]] && grep -cv '^category' "$file" || echo 0
}

do_json_findings() {
  local file="$1"
  if [[ ! -s "$file" ]]; then
    echo 0
    return
  fi
  # Try to detect newline-delimited JSON objects (JSONL)
  local line_count
  line_count=$(jq -c . "$file" 2>/dev/null | wc -l)
  if [[ "$line_count" -gt 1 ]]; then
    echo "$line_count"
  else
    # Try to parse as array or object
    jq 'if type == "array" then length else 1 end' "$file" 2>/dev/null | head -n1
  fi
}