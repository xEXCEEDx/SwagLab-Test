*** Settings ***
Library           SeleniumLibrary
Resource      ../resources/variables.robot
Resource      ../resources/keywords.robot
# Suite Setup       Open Browser To Sauce Demo
# Suite Teardown    Close Browser

*** Test Cases ***

Validate Chackout product Complete
    Open Browser To Sauce Demo
    Fill the login Form    ${USERNAME}    ${PASSWORD}
    Go to Chackout page
    Fill the checkout Form  ${FIRST_NAME}    ${LAST_NAME}    ${ZIP_CODE}
    [Teardown]      Close Browser
    

Validate Chackout For Non-Fill firstname
    Open Browser To Sauce Demo
    Fill the login Form    ${USERNAME}    ${PASSWORD}
    Go to Chackout page
    Fill the checkout Form  ${empty}    ${LAST_NAME}    ${ZIP_CODE}
    verify error messageInformation is correct  ${Error_Message_Information}  Error: First Name is required
    [Teardown]      Close Browser
    

Validate Chackout For Non-Fill lastname
    Open Browser To Sauce Demo
    Fill the login Form    ${USERNAME}    ${PASSWORD}
    Go to Chackout page
    Fill the checkout Form  ${FIRST_NAME}    ${empty}    ${ZIP_CODE}
    verify error messageInformation is correct  ${Error_Message_Information}  Error: Last Name is required
    [Teardown]      Close Browser

Validate Chackout For Non-Fill zipcode
    Open Browser To Sauce Demo
    Fill the login Form    ${USERNAME}    ${PASSWORD}
    Go to Chackout page
    Fill the checkout Form  ${FIRST_NAME}    ${LAST_NAME}    ${empty}
    verify error messageInformation is correct  ${Error_Message_Information}  Error: Postal Code is required
    [Teardown]      Close Browser

Validate button cancel
    Open Browser To Sauce Demo
    Fill the login Form    ${USERNAME}    ${PASSWORD}
    Go to Chackout page
    Click Element  css:.cart_cancel_link
    [Teardown]      Close Browser