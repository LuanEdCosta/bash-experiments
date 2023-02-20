#!/bin/bash

target_path="$1"
extensions="$2"
exclude_paths=${3:-"node_modules,.git,dist,build"}

if [ "$target_path" = "" ]; then
  read -p "Path: " target_path
fi

if [ "$target_path" = "" ]; then
  echo "Missing Path. Aborting..."
  exit 1
fi

if [ "$extensions" = "" ]; then
  read -p "File Extensions (Comma Separated Values): " extensions
fi

if [ "$extensions" = "" ]; then
  echo "Missing Extensions. Aborting..."
  exit 1
fi

echo "Find files by extensions: $extensions"
echo "Exclude Paths: $exclude_paths"

find_exclude_paths=''
for exclude_path in $(echo $exclude_paths | tr ',' ' ')
do
  find_exclude_paths="$find_exclude_paths -not -path */$exclude_path*"
done

total_of_lines=0
extensions=$(echo $extensions | sed 's/,/\\|/g')
files=$(find $target_path -iregex ".*\.\($extensions\)" $find_exclude_paths)

for file in $files
do
  number_of_lines=$(wc -l $file | awk '{print $1}')
  total_of_lines=$(echo "$total_of_lines + $number_of_lines" | bc)
done

number_of_files=$(if [ "$files" = "" ]; then echo 0; else echo $files" " | tr -cd ' \t' | wc -c | awk '{print $1}'; fi)

echo "Number of Files: $number_of_files"
echo "Total of Lines: $total_of_lines"
