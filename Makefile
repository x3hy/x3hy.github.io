PY := python3

all: update reload push

# Create a new journal entry
new_entry: data/vim.sh
	data/vim.sh

# Update the website
update: fetch.py
	$(PY) fetch.py

# Reload source.html
reload: generate.sh
	./generate.sh

push:
	git add .
	git commit -m "Auto-push: $(shell date)"
	git push

