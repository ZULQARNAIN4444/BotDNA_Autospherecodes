import pandas as pd        # pandas  used to read and write Excel files
import os                  # os is used to check if files/folders exist
import requests

URL = "https://rpachallenge.com/assets/downloadFiles/challenge.xlsx"



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