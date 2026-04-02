*** Settings ***
Library           Autosphere.Browser      # Library for browser automation (open browser, click, input text, etc.)
Library           Autosphere.Excel.Files      # Library for reading and writing Excel files
Library           Collections          # Library for dictionary and list operations
Library           OperatingSystem      # Library for file and folder operations
Library           excel_helper_RPA.py  # Python file for excel download        # Custom Python helper to save Excel data         
*** Variables ***
${URL}            https://rpachallenge.com/     # Website where the RPA Challenge form exists
${DOWNLOAD_PATH}  B:/BotsDNA                    # Folder where the Excel file will be downloaded
${EXCEL_FILE}     ${DOWNLOAD_PATH}/challenge.xlsx   # Full path of the Excel file that contains the data


*** Test Cases ***
Solve RPA Challenge

    Open Browser    ${URL}    chrome        # Opens Chrome browser and navigates to the RPA challenge website
    Maximize Browser Window                 # Makes the browser window full screen
    Set Selenium Timeout    5s              # Sets maximum wait time for Selenium operations to 5 seconds

    Ensure Excel Downloaded    ${EXCEL_FILE}

#    Download Excel If Needed                # Calls custom keyword to download Excel if it doesn't exist

    Click Element    xpath=//button[contains(text(),'Start')]   # Clicks the "Start" button on the website to begin the challenge
    Open Workbook    ${EXCEL_FILE}          # Opens the Excel file containing form data
    ${rows}=    Read Worksheet As Table    header=True   # Reads Excel data as a table using the first row as headers
    Close Workbook                         # Closes the Excel file after reading the data

    # Loop through each row in the Excel file
    FOR    ${row}    IN    @{rows}

        ${labels}=    Get WebElements    xpath=//label   # Gets all label elements on the webpage form


        # Loop through every label on the form
        FOR    ${label}    IN    @{labels}

            ${label_text}=    Get Text    ${label}   # Reads the text of the current label (e.g., "First Name", "Company Name")

            # Check if this label text exists as a column name in the Excel row
            ${exists}=    Run Keyword And Return Status
            ...    Dictionary Should Contain Key    ${row}    ${label_text}

            # If the label exists in the Excel row dictionary
            IF    ${exists}

                ${value}=    Get From Dictionary    ${row}    ${label_text}   # Get the value from Excel for this label

                # Find the input field that belongs to this label
                ${input}=    Get WebElement
                ...    xpath=//label[normalize-space()='${label_text}']/following-sibling::input

                Clear Element Text    ${input}      # Clears any existing text in the input field
                Input Text            ${input}    ${value}   # Types the Excel value into the input field

            END

        END

        Click Element    xpath=//input[@type='submit']   # Clicks the Submit button to send the form

    END

    Sleep    5s          # Waits 5 seconds so the user can see the final result
    Close Browser        # Closes the browser


*** Keywords ***
Setup Browser
    Create Directory    ${DOWNLOAD_PATH}     # Create download folder if it doesn't exist
    Open Browser    ${URL}    chrome         # Open Chrome browser and navigate to the notary website
    Maximize Browser Window                  # Maximize the browser window
    Set Selenium Implicit Wait    5
