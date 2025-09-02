*** Settings ***
Library                         QWeb
Library                         QForce
Library                         String


*** Variables ***
${home_url}                     ${sfdc_login_url}/lightning/page/home

*** Keywords ***
Setup Suite
    QWeb.Open Browser           about:blank                 chrome
    Set Library Search Order    QWeb                        QForce

Login to SF Trial Org
    Set Library Search Order    QWeb                        QForce
    GoTo                        https://www.salesforce.com/form/signup/freetrial-sales-pe/
    Sleep                       3
    VerifyText                  Start your free trial today
    sleep                       3

Login To SF Dev Org 

    GoTo                        ${login_sf_url}
    TypeText                    Username                    ${login_sf_username}
    TypeSecret                  Password                    ${login_sf_password}
    ClickText                   Log In
    LaunchApp                   Sales
    Sleep                       5

Home
    [Documentation]             Navigate to homepage, login if needed
    Set Library Search Order    QWeb                        QForce
    GoTo                        ${home_url}
    ${login_status} =           IsText                      To access this page, you have to log in to Salesforce.    2
    Run Keyword If              ${login_status}             Login To SF Dev Org
    ClickText                   Home
    VerifyTitle                 Home | Salesforce