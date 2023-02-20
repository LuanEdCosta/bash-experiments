#!/bin/bash

# check for correct number of arguments
if [ $# -lt 2 ]; then
  echo "Usage: $0 <path> <file_extensions> [exclude_paths...]"
  exit 1
fi

# set path and file extension variables
path=$1
file_extensions=$2

# set exclude paths
exclude_paths=""
if [ $# -gt 2 ]; then
  exclude_paths="! -path ${3}"
  shift 3
  while [ $# -gt 0 ]; do
    exclude_paths+=" ! -path ${1}"
    shift
  done
fi

# count number of files and lines
num_files=$(find ${path} -name "${file_extensions}" ${exclude_paths} -type f | wc -l)
total_lines=$(find ${path} -name "${file_extensions}" ${exclude_paths} -type f | xargs cat | wc -l)

# output results
echo "Number of files: ${num_files}"
echo "Total lines: ${total_lines}"
