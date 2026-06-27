#!/bin/sh
set -e  # Exit on any error

tmp=$(mktemp)
tmp_json=$(mktemp)
trap 'rm -f "$tmp" "$tmp_json"' EXIT

echo -e "Entry title\nEntry Body" > "$tmp"
vim "$tmp"

if [ $? -ne 0 ]; then
    echo "Error: vim failed."
    exit 1
fi

cur_time=$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")
post_uuid=$(uuidgen)

# More robust sanitization using jq (handles newlines, quotes, backslashes, control chars better)
title_content=$(head -n 1 "$tmp" | jq -Rs --arg t "$(head -n 1 "$tmp")" '$t')
body_content=$(tail -n +2 "$tmp" | jq -Rs --arg b "$(tail -n +2 "$tmp")" '$b')

# Create single entry
cat > "$tmp_json" << EOF
[{
  "title": $title_content,
  "body": $body_content,
  "time": "$cur_time",
  "uuid": "$post_uuid"
}]
EOF

echo "Entry located at phys: $tmp"
cat "$tmp_json"  # For debugging

# Append to journal (safer merge)
if [ -s journal.json ]; then
    jq --slurpfile new "$tmp_json" '. + $new[0]' journal.json > "$tmp"
    mv "$tmp" journal.json
else
    cp "$tmp_json" journal.json
fi

# Generate static page
mkdir -p pages

plate -I="$tmp_json" \
    -T='<h1><!--$title--></h1><sub>Posted <span class="date"> ago<!--$time--></span></sub><br><hr><p><div class="pre"><!--$body--></div></p>' \
    -i="post.html" \
	-t="PLATE_BODY" \
    -o="pages/$post_uuid.html"

echo "Generated: pages/$post_uuid.html"
