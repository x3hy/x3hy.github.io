#!/bin/mksh
# Generate website using data statically
#

# Remove old file
if [ -e index.html ];then
	rm index.html
fi

# Generate projects
new=$(plate --template="		<li><a href=\"<!--\$html_url-->\"><!--\$name--></a> - <!--\$description--></li>" -i=source.html -J=data/repo.json -L=!PLATE_PROJECTS -p="data")
echo "$new" > index.html
echo "Loaded projects"

# Load README
new=$(plate --template="<!--\$readme_txt-->" -i=index.html -J=data/user.json -L=!PLATE_ABOUTME)
echo "$new" > index.html
echo "Loaded README"

# Generate journals
new=$(plate --template="		<li><details><summary><!--\$title--> - <span class=\"date\"><!--\$time--></span> ago</summary><!--\$body--></details></li>" -i=index.html -p="journal" -J=data/journal.json -L=!PLATE_JOURNAL)
echo "$new" > index.html
echo "Loaded journal"
