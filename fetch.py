#!/usr/bin/python
# Fetches the json data from github

import json
from urllib.request import urlopen

GH_USER="x3hy"
USER_DAT_FILE="data/user.json"
REPO_DAT_FILE="data/repo.json"


# fetch a url and return its json data 
def fetch (url: str) -> str:
    out= str ("")
    if len (url):
        try:
            with urlopen (url) as data:
                out = data.read().decode()
        except Exception as err:
            print (f"ERROR: {err}: {url}")
            if "403" in str(err):
                print ("Fatal error (403 rate limit reached)")
                exit(1)
    return out

# Fetch url and convert to json
def fetch_json (url: str) -> str:
    return json.loads (fetch (url));


# Fetch user profile
user_data = fetch_json (f"https://api.github.com/users/{GH_USER}")

# Fetch follower info
user_data["followers_data"] = fetch_json (user_data["followers_url"])

# Fetch profile README
user_data["readme_txt"] = fetch(f"https://raw.githubusercontent.com/{GH_USER}/{GH_USER}/refs/heads/main/README")

with open (USER_DAT_FILE, 'w') as f:
    json.dump (user_data, f, indent=4)


# Fetch repo data ( along with README(s) )
repo_data = {}
repo_data["data"] = fetch_json (user_data["repos_url"])

for repo in repo_data["data"]:
    repo["raw_url"] = repo["html_url"].replace("github.com", "raw.githubusercontent.com")
    readme_url = f"{repo["raw_url"]}/refs/heads/{repo["default_branch"]}/README"
    
    readme_data = fetch (readme_url)
    if readme_data != "":
        repo["readme_url"] = readme_url
        repo["readme_txt"] = readme_data
    
    repo["tags_json"] = fetch_json (repo["tags_url"])

with open (REPO_DAT_FILE, 'w') as f:
    json.dump (repo_data, f, indent=4)

exit(0)
