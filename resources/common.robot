*** Settings ***
Library                         QWeb
Library                         QForce
Library                         String


*** Variables ***


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