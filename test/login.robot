*** Settings ***
Library           SeleniumLibrary
Resource      ../resources/variables.robot
Resource      ../resources/keywords.robot
# Suite Setup       Open Browser To Sauce Demo
Suite Teardown    Close Browser

*** Test Cases ***
Validate UnSuccesful Login - Valid Credentials
    Open Browser To Sauce Demo
    Fill the login Form    Nuttanon   123456
    wait until it checks and display error message
    verify error message is correct    ${Error_Message_Login}    Epic sadface: Username and password do not match any user in this service
    [Teardown]      Close Browser
    
Validate Succesful Login - Invalid Credentials
    Open Browser To Sauce Demo
    Fill the login Form    ${USERNAME}    ${PASSWORD}
    Page Should Contain    Sauce Labs Backpack
    [Teardown]      Close Browser
    

Check for Non-Filling Username
    Open Browser To Sauce Demo
    Fill the login Form    ${empty}    ${PASSWORD}
    Click Button    id=login-button
    Wait Until It Checks And Display Error Message
    Verify Error Message Is Correct    ${Error_Message_Login}    Epic sadface: Username is required
    [Teardown]      Close Browser 

Check for Non-Filling Password
    Open Browser To Sauce Demo
    Fill the login Form    ${USERNAME}    ${empty}
    Click Button    id=login-button
    Wait Until It Checks And Display Error Message
    Verify Error Message Is Correct    ${Error_Message_Login}    Epic sadface: Password is required
    [Teardown]      Close Browser

