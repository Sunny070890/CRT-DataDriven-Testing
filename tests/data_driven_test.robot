*** Settings ***
Library                         QWeb
Library                         DataDriver                  reader_class=TestDataApi    name=MOCK_DATA__1_.csv
Library                         String
Library                         DateTime
Resource                        ../resources/common.robot
Suite Setup                     Open Browser                about:blank                 Chrome
Suite Teardown                  Close All Browsers
Test Template                   Example Test

*** Test Cases ***
Example Test with ${Last Name} ${Mobile} ${Company}

*** Keywords ***
Example Test
    [Arguments]                 ${Last Name}                ${Mobile}                   ${Company}                ${Salutation}
    # Your tests here, this is just an example
    # just use the values from excel using variable names
    # ClickText                 ${Last Name}
    # VerifyText                ${Mobile}
    # VerifyText                ${Company}
    # VerifyText                ${Salutation}



----------------------------------------------
*** Settings ***

Documentation                   Suite to create Lead and Account
# Library                       QForce
Library                         QWeb
Library                         String
Library                         DateTime
Suite Setup                     Setup Suite
Suite Teardown                  QWeb.Close All Browsers
Resource                        ../resources/common.robot

*** Variables ***
${LEAD_BASE_TNAME}              Lead
${COMPANY_BASE_NAME}            Company
${BASE_MOBILE_PREFIX}           123456

*** Test Cases ***
Login to Salesforce
    Login To SF Dev Org

Creating Salesforce Lead
    Set Library Search Order    QWeb                        QForce
    ClickText                   Leads List
    ClickText                   Leads
    ClickText                   New
    UseModal                    On
    PickList                    Salutation                  Mr.
    # ${CURRENT_TIME}=          Get Current Date            result_format=%Y%m%d%H%M%S
    ${random_string}            Generate Random String      3                           chars=abcd
    ${LEAD_UNIQUE_NAME}=        Set Variable                ${LEAD_BASE_TNAME}_${random_string}
    ${COMPANY_UNIQUE_NAME}=     Set Variable                ${COMPANY_BASE_NAME}_${random_string}
    Log To Console              This is my Unique lead name: ${LEAD_UNIQUE_NAME}
    Log To Console              This is my Unique lead name: ${COMPANY_UNIQUE_NAME}


    TypeText                    *Company                    ${COMPANY_UNIQUE_NAME}
    TypeText                    Last Name                   ${LEAD_UNIQUE_NAME}

    # Get current timestamp for randomization
    ${current_time}=            Get Current Date            result_format=%Y%m%d%H%M%S
    # Extract last 4 characters from timestamp for randomization
    ${timestamp_suffix}=        Get Substring               ${current_time}             -4

    TypeText                    Mobile                      ${BASE_MOBILE_PREFIX}${timestamp_suffix}
    ClickText                   Save                        partial_match=False
    UseModal                    Off
    ClickText                   ${lead_unique_name}
    ClickText                   Details
    # CloseAllBrowsers

