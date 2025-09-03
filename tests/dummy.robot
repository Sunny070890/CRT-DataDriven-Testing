*** Settings ***
Resource                        ../resources/common.robot
Library                         QForce
Library                         OperatingSystem
Library                         String
Library                         DateTime
Suite Setup                     Setup Suite

*** Variables ***
${testdata_folder}              ${CURDIR}/../testdata
${original_file}                ${testdata_folder}/HPWH_Invoive_Upload_File.csv
${updated_file}                 ${testdata_folder}/HPWH_Invoive_Upload_File_updated.csv

*** Test Cases ***
Login to salesforce QA3_PASSWORD   
    Login To SF Dev Org
    ${mfa_code}=                GetOTP                      ${login_sf_username}                 ${secret}                   ${QA3_Password}
    TypeSecret                  Verification Code           ${mfa_code}
    ClickText                   Verify

Upload Invoice File
    [Documentation]             Verify that invoice file can be uploaded in IC portal
    
    # Setup and process data
    Setup Test Environment
    
    LaunchApp                   Midstream
    ClickItem                   search-button
    TypeText                    Search...                   energy solution             tag=input                   delay=2
    ClickItem                   Energy Solution             tag=span                    anchor=Contact • Energy Solution                        delay=2
    ClickText                   Log in to Experience as User                            timeout=200
    UseModal                    On
    ClickText                   IC Invoice Portal Version 2                             delay=2
    ClickText                   Upload Invoice Files

    Log To Console              This is OUTPUTDIR: ${OUTPUTDIR}
    Log To Console              This is CURDIR: ${CURDIR}
    
    # Process and update CSV data
    ${modified_content}=        Process And Update CSV Data
    Save Updated CSV File       ${modified_content}

    # Use the updated file for upload
    ${upload_file_path}=        Set Variable                ${updated_file}

    ClickText                   HPWHR                       anchor=IC Invoice File Upload
    VerifyText                  Selected Program Type : HPWHR                           delay=2
    ClickText                   V1                          anchor=IC Invoice File Upload                           delay=2
    VerifyText                  IC File Template Version : V1, Columns Count:           delay=2

    UpLoadFile                  Upload FilesOr drop files                               ${upload_file_path}         timeout=250
    UseModal                    On
    Sleep                       5s
    ClickText                   Done
    UseModal                    Off
    ClickText                   Submit
    LogScreenshot
    VerifyNoText                Please check the file format and upload again
    VerifyText                  Processed Successfully      timeout=250
    LogScreenshot
    CloseBrowser

*** Keywords ***
Setup Test Environment
    [Documentation]             Creates testdata folder if needed
    
    ${testdata_exists}=         Run Keyword And Return Status    Directory Should Exist    ${testdata_folder}
    IF    not ${testdata_exists}
        Create Directory        ${testdata_folder}
        Log To Console          Created testdata folder: ${testdata_folder}
    END
    
    Log To Console              Test environment ready!

Process And Update CSV Data
    [Documentation]             Reads CSV, modifies data, and returns updated content
    
    ${file_exists}=             Run Keyword And Return Status    File Should Exist    ${original_file}
    IF    not ${file_exists}
        Log To Console          Original file not found: ${original_file}
        Fail                    Original CSV file does not exist
    END
    
    ${file_content}=            Get File                    ${original_file}
    Log To Console              Original file content read successfully
    
    # Generate unique values
    ${timestamp}=               Get Current Date            result_format=%m%d%H%M%S
    ${invoice_unique}=          Generate Random String      4                           [NUMBERS]0123456789
    ${app_line_unique}=         Generate Random String      6                           [NUMBERS]123456789
    ${app_ext_unique}=          Generate Random String      4                           [NUMBERS]123456789
    
    # Update data
    ${updated_content}=         Replace String              ${file_content}             HPWHR-0725-2736             HPWHR-0725-${invoice_unique}
    Log To Console              Updated Invoice Number: HPWHR-0725-${invoice_unique}
    
    ${updated_content}=         Replace String              ${updated_content}          HPWHR-07252025-741827       HPWHR-${timestamp}-${app_line_unique}
    Log To Console              Updated Application Line External ID: HPWHR-${timestamp}-${app_line_unique}
    
    ${updated_content}=         Replace String              ${updated_content}          PR-HPWHR872836              PR-HPWHR87${app_ext_unique}
    Log To Console              Updated Application External ID: PR-HPWHR87${app_ext_unique}
    
    RETURN                      ${updated_content}

Save Updated CSV File
    [Arguments]    ${updated_content}
    Log To Console    🔍 CURDIR: ${CURDIR}
    Log To Console    🔍 EXECDIR: ${EXECDIR}
    Log To Console    🔍 OUTPUTDIR: ${OUTPUTDIR}
    Log To Console    🔍 Testdata folder: ${testdata_folder}
    Log To Console    🔍 Target file: ${updated_file}
    
    # ⭐ Create in direct testdata folder
    Create File    ${updated_file}    ${updated_content}    encoding=UTF-8
    
    # ⭐ Verify file created successfully
    File Should Exist    ${updated_file}
    ${size}=    Get File Size    ${updated_file}
    Log To Console    ✅ SUCCESS! File created in testdata: ${updated_file} (${size} bytes)
    
    # ⭐ Double check content
    ${saved_content}=    Get File    ${updated_file}
    ${lines}=    Get Line Count    ${saved_content}
    Log To Console    📄 File has ${lines} lines
