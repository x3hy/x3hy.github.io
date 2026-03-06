#!/bin/sh
tmp=$(mktemp)
echo "Entry title\nEntry Body" > "$tmp"
vim $tmp
if [ $? -ne 0 ]; then
	echo "Error occured."
	exit 1
fi

echo "entry located at phys $tmp"
cur_time=$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")
title_content="$(head -n 1 "$tmp")"
body_content="$(tail -n +2 "$tmp")"

# Set the entry
jq \
	--arg title "$title_content" \
	--arg body "$body_content" \
	--arg time "$cur_time" \
	'.journal += [{
		"title": $title,
		"body": $body,
		"time": $time,
	}]' journal.json > "$tmp"
if [ $? -eq 0 ]; then
	mv "$tmp" journal.json
	echo "Entry added."
else
	echo "Failed to generate JSON"
	exit 1
fi
