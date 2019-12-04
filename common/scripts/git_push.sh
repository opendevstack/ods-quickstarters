#!/bin/bash
set -eux

while [[ "$#" > 0 ]]; do case $1 in
  -d=*|--dir=*) directory="${1#*=}";;
  -d|--dir) directory="$2"; shift;;

  -u=*|--url=*) git_url_http="${1#*=}";;
  -u|--url) git_url_http="$2"; shift;;

  *) echo "Unknown parameter passed: $1"; exit 1;;
esac; shift; done

cd $directory

# clone first (there is ALWAYS a remote repo!)
git clone "$git_url_http"
# step inside cloned git repo
basename=$(basename $git_url_http)
cloned_git_fld_name=${basename%.*}	

files=$( ls $cloned_git_fld_name | grep -v ^l | wc -l)

if [ $files == 0 ]; then 
	echo "Init project from scratch $(pwd)"
	git init .
	git remote add origin "$git_url_http"
else
	echo "Upgrading existing project: ${git_url_http}"
	mv "$cloned_git_fld_name"/* .
	mv "$cloned_git_fld_name"/.[!.]* .
fi

git config user.email "undefined"
git config user.name "CD System User"

rm -rf "$cloned_git_fld_name"

git add --all .
git commit -m "Initial opendevstack commit"
git push -u origin master
