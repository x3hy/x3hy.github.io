#!/bin/python

from sys import argv
from datetime import datetime, UTC
from json import loads, dump

DAT_FILE = "journal.json"


def utc_now() -> str:
    """
    returns the time in utc
    """
    return str(datetime.now(UTC))


def form(body: str) -> str:
    """
    produces the form
    """

    out = {}
    out["title"] = input ("title: ")
    out["tags"] = []
    out["body"] = body

    print("Enter tags, enter 'quit' or 'exit' to exit loop")
    while True:
        tag = input(": ")
        if tag.lower() in ["quit", "exit"]:
            break

        out["tags"].append(tag)

    out["time"] = utc_now()
    return out

if __name__ == "__main__":
    try:
        open (DAT_FILE, "x")
    except Exception as err:
        print (err)

    if not len(argv) == 2:
        print (f"{argv[0]} <body>")
        exit (1)

    data = { "journal": []}
    count = 0;
    with open (DAT_FILE, "r") as f:
        cont = f.read()
        if not cont == "":
            try:
                data = loads (cont)
            except Exception as err: 
                print (err)
                print (cont)
                exit (1)

        data["journal"].append (form (argv[1]))
        count = len (data["journal"])

    with open (DAT_FILE, "w") as f:
        dump (data, f, indent=4)
    
    print(f"Entry #({count}) created")

    exit (0)
exit (1)
