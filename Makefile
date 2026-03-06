PY := python3


# Create a new journal entry
new: source/vim_entry.sh
	source/vim_entry.sh $(PY)

# Update the website
update: source/fetch.py
	$(PY) source/fetch.py

# Reload source.html
reload: generate.sh
	./generate.sh
