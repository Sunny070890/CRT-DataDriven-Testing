*** Settings ***
Resource                      ../resources/common.robot
Library                       DataDriver    reader_class=TestDataApi    name=Leads.csv    #iterates through the Leads csv
Suite Setup                   Setup Suite
Test Template                 Entering A Lead With Data

*** Test Cases ***
Entering A Lead With Data with ${First Name} ${Last Name}    ${Phone}    ${Company}    ${Website}
    [Tags]                    AllData

*** Keywords ***
Entering A Lead With Data
    [Arguments]               ${First Name}    ${Last Name}    ${Phone}    ${Company}    ${Website}
    [tags]                    Lead
    Home
    LaunchApp                 Sales

    ClickText                 Leads
    VerifyText                My Leads             timeout=120s
    ClickText                 New
    VerifyText                Lead Information
    UseModal                  On                          # Only find fields from open modal dialog

    TypeText                  First Name                  ${First Name}
    TypeText                  Last Name                   ${Last Name}
    Picklist                  Lead Status                 Working - Contacted
    TypeText                  Phone                       ${Phone}                    First Name
    TypeText                  Company                     ${Company}                  Last Name
    TypeText                  Website                     ${Website}

    ClickText                 Lead Source
    ClickText                 Web
    ClickText                 Save                        partial_match=False
    UseModal                  Off
    Sleep                     1

    #Delete the lead to clean up data
    LaunchApp                 Sales
    ClickText                 Leads
    VerifyText                My Leads             timeout=120s

    ClickText                 ${First Name}${Last Name}
    ClickText                 Show more actions
    ClickText                 Delete
    UseModal                  On
    ClickText                 Delete