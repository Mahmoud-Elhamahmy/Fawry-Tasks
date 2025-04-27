#!/bin/bash

# Function to show usage
show_help() {
    echo "Usage: $0 [OPTIONS] SEARCH_STRING FILE"
    echo "Options:"
    echo "  -n    Show line numbers"
    echo "  -v    Invert match (show non-matching lines)"
    echo "  --help  Show this help message"
}

# Check for help flag first
if [[ "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# Check if enough arguments
if [ $# -lt 2 ]; then
    echo "Error: Missing arguments."
    show_help
    exit 1
fi

# Initialize options
show_line_numbers=false
invert_match=false

# Parse options
while getopts ":nv" opt; do
  case $opt in
    n)
      show_line_numbers=true
      ;;
    v)
      invert_match=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      show_help
      exit 1
      ;;
  esac
done

# After options, get the search string and file
shift $((OPTIND -1))

search_string="$1"
file="$2"

# Check if search string or file is missing
if [ -z "$search_string" ] || [ -z "$file" ]; then
    echo "Error: Missing search string or file."
    show_help
    exit 1
fi

# Check if file exists
if [ ! -f "$file" ]; then
    echo "Error: File '$file' does not exist."
    exit 1
fi

# Read and process the file
line_number=0
while IFS= read -r line; do
    line_number=$((line_number +1))

    # Check match
    if echo "$line" | grep -i -q "$search_string"; then
        matched=true
    else
        matched=false
    fi

    # Invert match if -v is given
    if $invert_match; then
        if $matched; then
            continue
        fi
    else
        if ! $matched; then
            continue
        fi
    fi

    # Print line
    if $show_line_numbers; then
        printf "%d:%s\n" "$line_number" "$line"
    else
        echo "$line"
    fi
done < "$file"
