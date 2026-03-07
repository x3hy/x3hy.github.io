PY := python3

# Create a new journal entry
new: data/entry.sh
	data/entry.sh

# Update the website
update: data/fetch.py
	$(PY) data/fetch.py

# Reload source.html
reload: generate.sh
	./generate.sh

push:
	git add .
	git commit -m "Auto-push: $(shell date)"
	git push
