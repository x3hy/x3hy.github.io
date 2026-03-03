#!/bin/python
from json import loads

DAT_FILE = "journal.json"

if __name__ == "__main__":
    data={}
    with open (DAT_FILE) as f:
        data = loads(f.read());

    if not "journal" in data:
        exit(1)

    for entry in data["journal"]:
        print(
f"""
<code>{entry["body"]}</code>
""")

exit(0)
