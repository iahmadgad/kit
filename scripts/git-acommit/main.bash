#!/bin/bash
# Name: git-acommit
# Purpose: clean commit messages with angular convention
# Deps: git, git-cz
# Author: Ahmad Asaad

Help()
{
    echo -e "Usage: git acommit [option]
git advanced commit

when no option is selected commit staged files only.

  -t  <type>       commit type (e.g. feat, docs, fix, etc..)
  -s  <scope>      commit scope (e.g. chore(ci), chore(build, etc..)
  -b  <body        commit body
  -B  <change>     breaking change
  -m  <message>    commit message
  -c               commit all changed files (Staged & unstaged)
  -a               commit all files (Staged, unstaged, & untracked)
  -p               commit with problem solving message
  -i               commit with initial commit message
  -h               display this help message & exit"
}

while getopts ":t:s:b:B:m:capih" option; do
    case $option in
	t)
	    args="$args --type=$OPTARG"
	    ;;
	s)
	    args="$args --scope=$OPTARG"
	    ;;
	b)
	    args="$args --body=$OPTARG"
	    ;;
	B)
	    args="$args --breaking=$OPTARG"
	    ;;
      m)
	    commit_message="$OPTARG"
	    ;;
      s)
	 git add -u
	 ;;
      a) # commit all changes
         git add -A
         ;;
      h)
	 Help
	 exit
	 ;;
      p)
	  declare -A extensions=(
	      ["rs"]="Rust"
	      ["py"]="Python"
	      ["cpp"]="C++"
	      ["java"]="Java"
	      ["hs"]="Haskell"
	  )
	  path=$(git diff --cached --name-only)
	  file=$(basename $path)
	  problem=${file%.*}
	  extension=${file##*.}
	  if [[ $extension == "java" ]]
	  then
	      problem=${problem:1}
	  fi
	  message="Solve ${problem} in ${extensions[$extension]}"
	  git add $path
	  git commit -m "$message"
	  exit
	  ;;
      i)
	  git add -A
	  git commit -m "Initial commit"
	  exit
	  ;;
      \?) # Invalid option
	 echo "Invalid option"
         Help
         exit
	 ;;
   esac
done

# Check for any changes in the repository
changes=$(git status --porcelain)

if [ -z "$changes" ]; then
  echo "No changes to commit."
  exit 0
fi

if [ -z "$commit_message" ]; then
# Arrays to hold file lists
declare -a create_files
declare -a update_files
declare -a delete_files
declare -a rename_old_files
declare -a rename_new_files

# Loop through each change and categorize the files
while IFS= read -r line; do
  status=$(echo "$line" | cut -c1-2)
  file=$(echo "$line" | cut -c4-)
  
  case $status in
    A*)
      create_files+=("$file")
      ;;
    M*)
      update_files+=("$file")
      ;;
    D*)
      delete_files+=("$file")
      ;;
    R*)
      old_file=$(echo "$line" | awk '{print $2}')
      new_file=$(echo "$line" | awk '{print $4}')
      rename_old_files+=("$old_file")
      rename_new_files+=("$new_file")
      ;;
    *)
      continue
      ;;
  esac

done <<< "$changes"

# Build the commit message
commit_message=""

if [ ${#create_files[@]} -gt 0 ]; then
    create_message="Create "
    for i in ${!create_files[@]}; do
	create_message+="${create_files[$i]}, "
    done
    commit_message+="$create_message"
fi

if [ ${#update_files[@]} -gt 0 ]; then
    update_message="Update "
    for i in ${!update_files[@]}; do
        update_message+="${update_files[$i]}, "
    done
    commit_message+="$update_message"
fi

if [ ${#delete_files[@]} -gt 0 ]; then
    delete_message="Delete "
    for i in ${!delete_files[@]}; do
	delete_message+="${delete_files[$i]}, "
    done
    commit_message+="$delete_message"
fi

if [ ${#rename_old_files[@]} -gt 0 ]; then
  rename_message="Rename "
  for i in "${!rename_old_files[@]}"; do
    old_file="${rename_old_files[$i]}"
    new_file="${rename_new_files[$i]}"
    rename_message+="$old_file to $new_file, "
  done
  commit_message+="$rename_message"
fi

# Remove trailing comma and space
commit_message=${commit_message%, }

fi

# Commit the changes
git cz --disable-emoji --non-interactive $args --subject="$commit_message"

# For testing
#echo "Committed with message:"
#echo "$commit_message"