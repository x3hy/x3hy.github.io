#!/bin/sh
set -e  # Exit on any error

tmp=$(mktemp)
tmp_json=$(mktemp)
trap 'rm -f "$tmp" "$tmp_json"' EXIT

# Check JQ is installed
if ! command -v jq >/dev/null 2>&1; then
	echo "install JQ"
	exit
fi

# Check VIM is installed
if ! command -v vim >/dev/null 2>&1; then
	echo "install VIM"
	exit
fi

# Open in vim
echo -e "Entry title\nEntry Body" > "$tmp"
vim "$tmp"
if [ $? -ne 0 ]; then
    echo "Error: vim failed."
    exit 1
fi

cur_time=$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")
post_uuid=$(uuidgen)

# Sanitise information
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
    -T='<h1><!--$title--></h1><sub>Posted <span class="date"><!--$time--></span> ago</sub><br><hr><p><div class="pre"><!--$body--></div></p>' \
    -i="post.html" \
	-t="PLATE_BODY" \
    -o="pages/$post_uuid.html"

if [ $? -ne 0 ]; then
	echo "Plate failed to run"
	echo "$title_content" > plate_fail
	echo "$body_content" >> plate_fail

else echo "Generated: pages/$post_uuid.html"
fi

# After page generation we can remove the body
# from the json file
grep --include="*" '^[[:space:]]*"body"[[:space:]]*:' -v journal.json > "$tmp_json"
mv "$tmp_json" journal.json
