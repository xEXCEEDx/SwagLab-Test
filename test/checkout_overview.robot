*** Settings ***
Library           SeleniumLibrary
Resource      ../resources/variables.robot
Resource      ../resources/keywords.robot
# Suite Setup       Open Browser To Sauce Demo
# Suite Teardown    Close Browser

*** Test Cases ***
Chackout overview product Complete
    Open Browser To Sauce Demo
    Fill the login Form    ${USERNAME}    ${PASSWORD}
    Select Product to Cart    Sauce Labs Backpack
    Click element    css=.shopping_cart_link
    Wait Until Element Is Visible    xpath=//*[@id="checkout"]    timeout=10s
    Click button       xpath=//*[@id="checkout"]
    Fill the checkout Form  ${FIRST_NAME}    ${LAST_NAME}    ${ZIP_CODE}
    Click Element  xpath=//button[@id='finish']
    Page Should Contain Element    xpath=//h2[normalize-space()='Thank you for your order!']

    [Teardown]      Close Browser

Validate price total and tax 
    Open Browser To Sauce Demo
    Fill the login Form    ${USERNAME}    ${PASSWORD}
    Select Product to Cart    Sauce Labs Backpack
    Click element    css=.shopping_cart_link
    Wait Until Element Is Visible    xpath=//*[@id="checkout"]    timeout=10s
    Click button       xpath=//*[@id="checkout"]
    Fill the checkout Form  ${FIRST_NAME}    ${LAST_NAME}    ${ZIP_CODE}
    Check Price total and tex 
    [Teardown]      Close Browser

Validate button cancel overview
    Open Browser To Sauce Demo
    Fill the login Form    ${USERNAME}    ${PASSWORD}
    Select Product to Cart    Sauce Labs Backpack
    Click element    css=.shopping_cart_link
    Wait Until Element Is Visible    xpath=//*[@id="checkout"]    timeout=10s
    Click button       xpath=//*[@id="checkout"]
    Fill the checkout Form  ${FIRST_NAME}    ${LAST_NAME}    ${ZIP_CODE}
    Click Element  id=cancel
    Page Should Contain Element    xpath=//div[@id='inventory_container']//div//div[@id='inventory_container']
    [Teardown]      Close Browser

Validate Chackout complete and go to homepage
    Open Browser To Sauce Demo
    Fill the login Form    ${USERNAME}    ${PASSWORD}
    Select Product to Cart    Sauce Labs Backpack
    Click element    css=.shopping_cart_link
    Wait Until Element Is Visible    xpath=//*[@id="checkout"]    timeout=10s
    Click button       xpath=//*[@id="checkout"]
    Fill the checkout Form  ${FIRST_NAME}    ${LAST_NAME}    ${ZIP_CODE}
    Click Element  xpath=//button[@id='finish']
    Page Should Contain Element    xpath=//h2[normalize-space()='Thank you for your order!']
    Click Element  xpath=//button[normalize-space()='Back Home']
    Page Should Contain Element    xpath=//div[@id='inventory_container']
    [Teardown]      Close Browser
    
