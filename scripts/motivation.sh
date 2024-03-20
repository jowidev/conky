#!/bin/bash

# Path to your text file
TEXT_FILE="/home/jowidev/a.txt"

# Select a random line from the text file
RANDOM_LINE=$(shuf -n 1 "$TEXT_FILE")

# Function to find last space before the 30th char
split_line_at_last_space() {
    local line=$1
    local first_part=${line:0:30}
    local last_space_pos=0

    # Reverse the string to find the last space by finding the first space in reversed string
    local reversed=$(echo "$first_part" | rev)
    
    # Find the position of first space in reversed (which is last in original)
    local space_pos_reversed=$(expr index "$reversed" " ")
    
    if [ "$space_pos_reversed" -gt 0 ]; then
        # Calculate position of last space in original string
        last_space_pos=$((30 - space_pos_reversed + 1))
        echo "${line:0:last_space_pos-1}\n${line:last_space_pos-1}"
    else
        # If no space found before 30th char, return the line unchanged
        echo "$line"
    fi
}

# Function to add a line break after the 60th character, counting from the first line break
add_line_break() {
    local line=$1
    local line_length=${#line}
    local first_break_pos=$(echo "$line" | grep -b -m 1 -o $'\n' | head -n 1 | cut -d':' -f1)

    if [ "$line_length" -gt 60 ] && [ "$first_break_pos" -lt 60 ]; then
        echo "${line:0:60}\n${line:60}"
    else
        echo "$line"
    fi
}

# Use the function to split the line, if necessary
RANDOM_LINE=$(split_line_at_last_space "$RANDOM_LINE")

# Use the function to add a line break, if necessary
RANDOM_LINE=$(add_line_break "$RANDOM_LINE")

# Print the modified or unmodified random line
echo -e "$RANDOM_LINE"

