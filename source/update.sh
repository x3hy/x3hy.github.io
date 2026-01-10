#!/usr/local/bin/bash
# Fetch my user information from github

# Confirm requirements
REQUIREMENTS=( jq curl ) 
for req in "${REQUIREMENTS[@]}"; do 
	if ! command -v $req; then 
		echo "\"$req\" not installed."
		exit
	fi
done

# Error checking on curl
function curl_safe(){
	ret=0;
	if [ -n "$2" ]; then
		touch "$2"
		curl "$1" -o "$2"
		ret=$?
	elif [ -n "$1" ]; then
		curl "$1"
		ret=$?
	fi 

	if [ $ret -ne 0 ]; then
		exit
	fi
}

# Main variables
GIT_USER="x3hy"
REPO_DAT_FILE="data.json"
USER_DAT_FILE="user.json"
README_DAT_FILE="readme.json"
FOLLOWERS_DAT_FILE="followers.json"
FILES=( $REPO_DAT_FILE $USER_DAT_FILE $README_DAT_FILE ) 

# Fetch the data
echo "Fetching Data"
curl_safe "https://api.github.com/users/$GIT_USER/repos" "$REPO_DAT_FILE"
curl_safe "https://api.github.com/users/$GIT_USER" "$USER_DAT_FILE"
curl_safe "https://api.github.com/users/$GIT_USER/followers" "$FOLLOWERS_DAT_FILE"
README_DAT=$(curl_safe "https://raw.githubusercontent.com/$GIT_USER/refs/heads/main/README")

# Write profile README to json file
jq -n --arg value "$README_DAT" '{"readme":$value}' > $README_DAT_FILE

# Update git without adding 
# files that may not be wanted
for r in "${FILES[@]}"; do
	echo -n " $r"
	git add "$r"
done

echo -e "\nDone"
