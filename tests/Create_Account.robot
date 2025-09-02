*** Settings ***
Resource                   ../resources/common.robot
Suite Setup                Setup Suite
Test Template              Entering A Lead With Data
Library                    QForce

*** Test Cases ***
Craeate New Acc using REST TestDataApi
    Authenticate    ${client_id}    ${client_secret}    ${username}    ${password}    sandbox=false