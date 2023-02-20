#!/bin/bash

TARGET_PATH="$1"
EXTENSIONS="$2"

if [ "$TARGET_PATH" = "" ]; then
  read -p "Path: " TARGET_PATH
fi

if [ "$TARGET_PATH" = "" ]; then
  echo "Missing Path. Aborting..."
  exit 1
fi

if [ "$EXTENSIONS" = "" ]; then
  read -p "File Extensions: " EXTENSIONS
fi

if [ "$EXTENSIONS" = "" ]; then
  echo "Missing Extensions. Aborting..."
  exit 1
fi

echo "Filtering by file extensions: $EXTENSIONS"

TOTAL_OF_LINES=0
EXTENSIONS="$(echo $EXTENSIONS | sed 's/,/\\|/g')\\"
FILES=$(find $TARGET_PATH -iregex ".*\.\($EXTENSIONS)")

for FILE in $FILES
do
  NUMBER_OF_LINES=$(wc -l $FILE | awk '{print $1}')
  TOTAL_OF_LINES=$(echo "$TOTAL_OF_LINES + $NUMBER_OF_LINES" | bc)
done

NUMBER_OF_FILES=$(if [ "$FILES" = "" ]; then echo 0; else echo $FILES" " | tr -cd ' \t' | wc -c | awk '{print $1}'; fi)
echo "Number of Files: $NUMBER_OF_FILES"
echo "Total of Lines: $TOTAL_OF_LINES"
