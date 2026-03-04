#!/bin/sh
# Generate website using data from source
#

# Remove old file
rm index.html

# Generate projects
plate --template="		<li><a><!--\$name--></a> <!--\$description--></li>" -i=source.html -J=source/repo.json -L=!PLATE_PROJECTS -p="data" > index.html


new=$(plate --template="<!--\$readme_txt-->" -i=index.html -J=source/user.json -L=!PLATE_ABOUTME)
echo "$new" > index.html

# Generate journals
new=$(plate --template="		<li><!--\$title--> - <!--\$subject--></li>" -i=index.html -p="journal" -J=source/journal.json -L=!PLATE_JOURNAL)
echo "$new" > index.html
