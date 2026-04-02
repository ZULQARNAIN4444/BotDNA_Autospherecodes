# school_excel_helper.py
import pandas as pd
import requests
import os

URL=  "https://botsdna.com/school/Master%20Template.xlsx"

def ensure_excel_downloaded(path):

    # Check if file already exists
    if os.path.exists(path):
        return   # If it exists, do nothing

    print("Downloading Excel file...")

    # Download Excel file from website
    r = requests.get(URL)

    # Save downloaded file to given path
    with open(path, "wb") as f:
        f.write(r.content)


def save_excel_data(file_path, data, sheet_name="Sheet1"):
    """
    Saves a list of dictionaries to an Excel file using pandas.
    Overwrites the existing sheet completely.

    :param file_path: Path to Excel file
    :param data: List of dictionaries [{col1: val1, col2: val2}, ...]
    :param sheet_name: Excel sheet name
    """
    # Read existing Excel
    try:
        df = pd.read_excel(file_path)
    except FileNotFoundError:
        # If file doesn't exist, create empty df
        df = pd.DataFrame()

    # Convert new data to DataFrame
    new_df = pd.DataFrame(data)

    # If original file exists, remove rows with same index as new data
    # (optional, depends on your workflow)

    # Save new data to Excel
    new_df.to_excel(file_path, sheet_name=sheet_name, index=False)