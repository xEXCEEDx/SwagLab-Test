*** Settings ***
Library           SeleniumLibrary
Resource      ../resources/variables.robot
Resource      ../resources/keywords.robot
# Suite Setup       Open Browser To Sauce Demo
Suite Teardown    Close Browser

***Test Cases***

Testing adding and deleting products
    Open Browser To Sauce Demo
    Fill the login Form    ${USERNAME}    ${PASSWORD}
    Wait Until Element Is Visible    id=inventory_container    timeout=10s
    Select Product to Cart    Sauce Labs Bike Light
    Select Product to Cart    Sauce Labs Bolt T-Shirt
    Select Product to Cart    Sauce Labs Fleece Jacket

Validate count of products in the cart and delete one
    Validate the display quantity in the basket
    Remove Product   Sauce Labs Fleece Jacket
    sleep   2s
    Validate the display quantity in the basket
    
Check Quantity in Basket and Test Deletion
    Click element    css=.shopping_cart_link
    Wait Until Element Is Visible   id=cart_contents_container  timeout=10s
    Validate Quantity Products in Cart and count Product icon
    Remove Product from Cart    Sauce Labs Bike Light
    Wait Until Element Contains    css=.shopping_cart_badge    text=1  timeout=10s
    Validate Quantity Products in Cart and count Product icon
    
Checks button to continue shopping
    Click button       id=continue-shopping
    Wait Until Element Is Visible    id=inventory_container    timeout=10s


