*** Settings ***
Resource                   ../resources/common.robot
Library                    DataDriver                  reader_class=TestDataApi    name=testdata1.xlsx    #iterates through the Leads csv
Suite Setup                Setup Suite
Test Template              Entering A Lead With Data

*** Test Cases ***
Entering A Lead With Data with ${First Name} ${Last Name}    ${Mobile}    ${Company}    ${Website}
    [Tags]                 AllData

*** Keywords ***
Entering A Lead With Data
    [Arguments]            ${First Name}               ${Last Name}                ${Mobile}             ${Company}                  ${Website}
    [tags]                 Lead
    # Home
    Login To SF Dev Org
    ClickText              Leads List
    ClickText              Leads
    ClickText              New
    UseModal               On
    PickList               Salutation                  Mr.
    TypeText               First Name                  ${First Name}
    TypeText               *Company                    ${Company}
    TypeText               Last Name                   ${Last Name}
    TypeText               Mobile                      ${Mobile}
    TypeText               Website                     ${Website}
    ClickText              Save                        partial_match=False
    UseModal               Off



    # Delete the lead to clean up data
    LaunchApp              Sales
    ClickText              Leads
    VerifyText             Recently Viewed             timeout=120s

    ClickText              ${First Name} ${Last Name}
    ClickText              Show more actions
    ClickText              Delete
    UseModal               On
    ClickText              Delete