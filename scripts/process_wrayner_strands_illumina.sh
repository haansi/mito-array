#!/bin/bash

# URL of the webpage containing the links
URL="https://www.chg.ox.ac.uk/~wrayner/strand/ilmnStrand/index.html"

# Directory to store downloaded and extracted files
DOWNLOAD_DIR="Wrayner_Strands_Illumina"
mkdir -p "$DOWNLOAD_DIR"
cd "$DOWNLOAD_DIR" || exit

BASE_DOWNLOAD_URL=$(echo "$URL" | sed 's|/[^/]*$||')

LINKS=$(curl -s "$URL" | grep -oP '(?i)href="\K[^"]*b37[^"]*\.zip')

if [ -z "$LINKS" ]; then
    echo "No Cardio*b37*.zip files found on the webpage."
    exit 1
fi

for LINK in $LINKS; do
    FULL_URL="${BASE_DOWNLOAD_URL}/${LINK}"
    FILENAME=$(basename "$LINK")
    BASE_FILENAME="${FILENAME%.zip}"
    EXTRACTED_DIR="${BASE_FILENAME}"
    OUTPUT_FILE="${BASE_FILENAME}_MT.txt"

    echo "Processing $FILENAME..."
    echo "Downloading from: $FULL_URL"

    wget -nc "$FULL_URL"

    if [ $? -ne 0 ]; then
        echo "Error: Failed to download $FILENAME. Skipping."
        continue
    fi

    mkdir -p "$EXTRACTED_DIR"
    unzip -d "$EXTRACTED_DIR" "$FILENAME"

    if [ $? -ne 0 ]; then
        echo "Error: Failed to unzip $FILENAME. Skipping."
        rm -rf "$EXTRACTED_DIR"
        continue
    fi

    # 5. FIX: Find the main data file within the extracted directory.
    #    - The previous command was too specific with file extensions.
    #    - This now finds the first regular file found inside the extracted folder.
    DATA_FILE=$(find "$EXTRACTED_DIR" -type f | head -n 1)

    if [ -z "$DATA_FILE" ]; then
        echo "Warning: Could not find a suitable data file in $EXTRACTED_DIR. Skipping awk."
        continue
    fi
    
    echo "Processing data file: $DATA_FILE"

    # 6. Use awk to filter for "MT" in the second column and save to a new file
    awk '$2 == "MT"' "$DATA_FILE" > "$OUTPUT_FILE"

    echo "Found $(wc -l < "$OUTPUT_FILE") entries and saved to $OUTPUT_FILE"
    echo "----------------------------------------"
done

echo "Script finished."
