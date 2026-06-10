
*** Settings ***
Library    Autosphere.Archive
Library    Autosphere.FileSystem
Library    Autosphere.HTTP
Library    Autosphere.Browser
Library    String

*** Variables ***
${URL}            https://botsdna.com/BGV/
${DOWNLOAD_DIR}   B:/BotsDNA-AutosphereCode/EmployeeDocument
${FILE_NAME}      Employee Documents.zip
${FILE_URL}       ${URL}${FILE_NAME}
${EXTRACT_DIR}    B:/BotsDNA-AutosphereCode/EmployeeDocument/extracted

*** Keywords ***
Get File Pattern
    [Arguments]    ${missing_item}
    ${term}=    Evaluate    $missing_item.strip().replace(' MarkList','').replace(' Certificate','').replace(' Offer Letter','+Offer').replace(' Experience Letter','+Experience')
    ${pattern}=    Evaluate    $term.replace('+','*')
    [Return]    ${pattern}

*** Tasks ***
Dynamic BGV Upload
    Create Directory    ${DOWNLOAD_DIR}
    Download    ${FILE_URL}    ${DOWNLOAD_DIR}/${FILE_NAME}
    Wait Until Created    ${DOWNLOAD_DIR}/${FILE_NAME}    60
    Create Directory    ${EXTRACT_DIR}
    Extract Archive    ${DOWNLOAD_DIR}/${FILE_NAME}    ${EXTRACT_DIR}
    Open Browser    ${URL}    chrome
    FOR    ${i}    IN RANGE    10
        ${emp_id}=    Get Value    id=CurrentEmpID
        ${missing_docs}=    Get Text    id=MissingDocs
        Log    Employee ${i+1}: ${emp_id}    console=True
        Log    Missing: ${missing_docs}    console=True
        ${emp_folder}=    Find Files    ${EXTRACT_DIR}/**/*${emp_id}*    include_files=False
        Create Directory    ${emp_folder}[0]/Upload
        @{missing_items}=    Split String    ${missing_docs}    ${SPACE}/${SPACE}
        FOR    ${item}    IN    @{missing_items}
            ${pattern}=    Get File Pattern    ${item}
            ${files}=    Find Files    ${emp_folder}[0]/*${pattern}*    include_dirs=False
            Copy Files    ${files}    ${emp_folder}[0]/Upload
        END
        Archive Folder With Zip    ${emp_folder}[0]/Upload    ${emp_folder}[0]/Upload.zip
        Choose File    id=uploadedFile    ${emp_folder}[0]/Upload.zip
        Click Button    id=Submit
    END
