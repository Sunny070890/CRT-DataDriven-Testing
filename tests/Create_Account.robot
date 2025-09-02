*** Settings ***
Resource            ../resources/common.robot
Suite Setup         Setup Suite
Library             QForce

*** Test Cases ***
Craeate New Acc using REST TestDataApi
    Authenticate    ${client_id}                ${client_secret}    ${login_sf_username}    ${login_sf_password}    sandbox=false