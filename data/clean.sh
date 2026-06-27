#!/bin/sh
set -ex
find pages/ -type f | while read path; do
	rm "$path" -f
done

echo "[]" > journal.json
set +ex
