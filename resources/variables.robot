*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${URL}                  https://www.saucedemo.com
${BROWSER}              Chrome
${USERNAME}       standard_user
${PASSWORD}       secret_sauce  
${Error_Message_Login}       css:h3[data-test='error']

${FIRST_NAME}       Test
${LAST_NAME}        Test
${ZIP_CODE}         12345
${Error_Message_Information}     css:h3[data-test='error']