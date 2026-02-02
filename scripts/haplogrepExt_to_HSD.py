import csv
import argparse
import sys
from typing import List

def filter_haplogrep_output(input_path: str, output_path: str):
    """
    Reads a tab-delimited haplogroup extended output file and writes a new
    file containing only the 'SampleID', 'Range', 'Haplogroup', and 'Input_Sample' columns.

    Args:
        input_path: Path to the input tab-delimited file.
        output_path: Path to the desired output file.
    """
    # Define the columns we want to keep, in the desired order
    TARGET_COLUMNS = ["SampleID", "Range", "Haplogroup", "Input_Sample"]

    try:
        # 1. Read the input file
        with open(input_path, 'r', newline='', encoding='utf-8') as infile:
            # Use 'excel-tab' dialect for tab-delimited files
            reader = csv.DictReader(infile, dialect='excel-tab')
            input_data: List[dict] = list(reader)

    except FileNotFoundError:
        print(f"Error: Input file not found at {input_path}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"An error occurred while reading {input_path}: {e}", file=sys.stderr)
        sys.exit(1)

    # Check if the necessary columns are present in the input file
    header = reader.fieldnames
    if header:
        missing_columns = [col for col in TARGET_COLUMNS if col not in header]
        if missing_columns:
            print(f"Error: Input file is missing the following required columns: {', '.join(missing_columns)}", file=sys.stderr)
            print(f"Available columns in input file: {', '.join(header)}", file=sys.stderr)
            sys.exit(1)
    else:
        print("Error: Input file appears to be empty or has no header.", file=sys.stderr)
        sys.exit(1)


    # 2. Write the filtered output file
    try:
        with open(output_path, 'w', newline='', encoding='utf-8') as outfile:
            writer = csv.DictWriter(
                outfile,
                fieldnames=TARGET_COLUMNS,
                delimiter='\t',
                extrasaction='ignore' # Ignore columns not in TARGET_COLUMNS
            )

            # Write the header row
            writer.writeheader()

            # Write the data rows
            for row in input_data:
                # DictWriter automatically handles filtering based on 'fieldnames'
                writer.writerow(row)

        print(f"\nSuccessfully filtered file. Output written to: {output_path}")

    except Exception as e:
        print(f"An error occurred while writing to {output_path}: {e}", file=sys.stderr)
        sys.exit(1)


# --- Main Execution Block ---

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Filter Haplogrep extended output to keep only SampleID, Range, Haplogroup, and Input_Sample."
    )
    # Define required positional arguments for input and output files
    parser.add_argument(
        "input_file",
        help="Path to the input tab-delimited Haplogrep extended output file."
    )
    parser.add_argument(
        "output_file",
        help="Path for the new, filtered tab-delimited output file."
    )

    args = parser.parse_args()

    filter_haplogrep_output(args.input_file, args.output_file)
