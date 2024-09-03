import csv
import sys

file_path = sys.argv[1]
with open(file_path, "r") as f:
    reader = csv.reader(f)
    rows = list(reader)
    for row in rows:
        print(len(row), row)
