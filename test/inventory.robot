*** Settings ***
Library           SeleniumLibrary
Resource      ../resources/variables.robot
Resource      ../resources/keywords.robot
# Suite Setup       Open Browser To Sauce Demo
Suite Teardown    Close Browser


*** Test Cases ***
Check login to page Products
    Open Browser To Sauce Demo
    Fill the login Form    ${USERNAME}    ${PASSWORD}
    [Teardown]      Close Browser
    
Validate Cards display in the Shopping Page
    Open Browser To Sauce Demo
    Fill the login Form    ${USERNAME}    ${PASSWORD}
    Wait Until Element Is Visible   id=inventory_container  timeout=10s
    Verify Card titles in the Shop page
    [Teardown]      Close Browser

Validate SortProduct Dropdown
    Open Browser To Sauce Demo
    Fill the login Form  ${USERNAME}  ${PASSWORD}
    Click Element  css:.product_sort_container
    Test SortProduct Option   Price (high to low)
    Test SortProduct Option   Price (low to high)
    Test SortProduct Option   Name (A to Z)
    Test SortProduct Option   Name (Z to A)
    [Teardown]      Close Browser

Validate sidebar
    Open Browser To Sauce Demo
    Fill the login Form  ${USERNAME}  ${PASSWORD}
    Validate Sidebar
    [Teardown]      Close Browser

