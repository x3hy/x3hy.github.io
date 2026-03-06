PY := python3

# Create a new journal entry
new: source/entry.sh
	source/entry.sh

# Update the website
update: source/fetch.py
	$(PY) source/fetch.py

# Reload source.html
reload: generate.sh
	./generate.sh

push:
	git add .
	git commit -m "Auto-push: $(shell date)"
	git push
