#!/bin/bash

TARGET_PATH="$1"
EXTENSIONS="$2"
EXCLUDE_PATHS=${3:-"node_modules,.git,dist,build"}

if [ "$TARGET_PATH" = "" ]; then
  read -p "Path: " TARGET_PATH
fi

if [ "$TARGET_PATH" = "" ]; then
  echo "Missing Path. Aborting..."
  exit 1
fi

if [ "$EXTENSIONS" = "" ]; then
  read -p "File Extensions (Comma Separated Values): " EXTENSIONS
fi

if [ "$EXTENSIONS" = "" ]; then
  echo "Missing Extensions. Aborting..."
  exit 1
fi

echo "Find files by extensions: $EXTENSIONS"
echo "Exclude Paths: $EXCLUDE_PATHS"

FIND_EXCLUDE_PATHS=''
for EXCLUDE_PATH in $(echo $EXCLUDE_PATHS | tr ',' ' ')
do
  FIND_EXCLUDE_PATHS="$FIND_EXCLUDE_PATHS -not -path */$EXCLUDE_PATH*"
done

TOTAL_OF_LINES=0
EXTENSIONS=$(echo $EXTENSIONS | sed 's/,/\\|/g')
FILES=$(find $TARGET_PATH -iregex ".*\.\($EXTENSIONS\)" $FIND_EXCLUDE_PATHS)

for FILE in $FILES
do
  NUMBER_OF_LINES=$(wc -l $FILE | awk '{print $1}')
  TOTAL_OF_LINES=$(echo "$TOTAL_OF_LINES + $NUMBER_OF_LINES" | bc)
done

NUMBER_OF_FILES=$(if [ "$FILES" = "" ]; then echo 0; else echo $FILES" " | tr -cd ' \t' | wc -c | awk '{print $1}'; fi)

echo "Number of Files: $NUMBER_OF_FILES"
echo "Total of Lines: $TOTAL_OF_LINES"
