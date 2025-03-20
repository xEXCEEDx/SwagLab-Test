*** Settings ***
Library           SeleniumLibrary
Library           Collections
Library           BuiltIn
*** Keywords ***
Open Browser To Sauce Demo
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
   

    
Fill the login Form
    [Arguments]    ${USERNAME}    ${PASSWORD}
    Input Text    id=user-name    ${USERNAME}
    Input Text    id=password    ${PASSWORD}
    Click Button    id=login-button

wait until it checks and display error message
    Wait Until Page Contains Element    ${Error_Message_Login}  timeout=10s
    

verify error message is correct
    [Arguments]    ${element_locator}    ${expected_message}
    Element Text Should Be    ${element_locator}    ${expected_message}

    
Verify Card titles in the Shop page
    @{expectedList} =    Create List    Sauce Labs Bike Light    Sauce Labs Bolt T-Shirt    Sauce Labs Fleece Jacket    Sauce Labs Onesie    Test.allTheThings() T-Shirt (Red)
    ${elements} =    Get WebElements    xpath= (//div[@class='inventory_item'])
    @{actualList} =   Create List
    FOR  ${element}  IN  @{elements}
        Log   ${element.text}
        Append To List    ${actualList}    ${element.text}
    END

Test SortProduct Option
    [Arguments]    ${expectedOption}
    
    # เลือกตัวเลือกใน dropdown
    Log    กำลังเลือกตัวเลือก: ${expectedOption}
    Select From List By Label    css=.product_sort_container    ${expectedOption}
    ${selectedOption}=    Get Selected List Label    css=.product_sort_container
    Should Be Equal As Strings    ${selectedOption}    ${expectedOption}
    Log    เลือกตัวเลือกสำเร็จ: ${selectedOption}
    
    # ตรวจสอบการเรียงลำดับ
    Run Keyword If    '${expectedOption}' == 'Price (low to high)'    Validate Price Sorting    asc
    Run Keyword If    '${expectedOption}' == 'Price (high to low)'    Validate Price Sorting    desc
    Run Keyword If    '${expectedOption}' == 'Name (A to Z)'    Validate Name Sorting    asc
    Run Keyword If    '${expectedOption}' == 'Name (Z to A)'    Validate Name Sorting    desc

Validate Price Sorting
    [Arguments]    ${order}
    
    # ดึงราคาสินค้าทั้งหมด
    @{price_elements}=    Get WebElements    css=.inventory_item_price
    @{actual_prices}=    Create List
    
    # ดึงข้อมูลราคาและบันทึกใน log
    Log    กำลังตรวจสอบการเรียงลำดับตามราคา (${order})
    
    FOR    ${index}    ${element}    IN ENUMERATE    @{price_elements}
        ${price_text}=    Get Text    ${element}
        ${price}=    Set Variable    ${price_text.replace('$', '')}    # ลบสัญลักษณ์ $
        ${price}=    Convert To Number    ${price}
        Append To List    ${actual_prices}    ${price}
        Log    สินค้าลำดับที่ ${index+1}: ${price_text} -> ${price}
    END
    
    # สร้างรายการที่จะใช้เปรียบเทียบ
    ${expected_prices}=    Copy List    ${actual_prices}
    
    # การเรียงลำดับข้อมูล
    ${sorted_expected}=    Copy List    ${expected_prices}
    
    # กรณีเรียงจากต่ำไปสูง (ascending)
    Run Keyword If    '${order}' == 'asc'    Sort List    ${sorted_expected}
    
    # กรณีเรียงจากสูงไปต่ำ (descending)
    ${desc_list}=    Copy List    ${sorted_expected}
    Run Keyword If    '${order}' == 'desc'    Sort List    ${desc_list}
    Run Keyword If    '${order}' == 'desc'    Reverse List    ${desc_list}
    Run Keyword If    '${order}' == 'desc'    Set Variable    ${sorted_expected}    ${desc_list}
    
    # บันทึกข้อมูลการเปรียบเทียบใน log
    Log    ราคาที่ควรเป็น: ${sorted_expected}
    Log    ราคาจริงบนเว็บ: ${actual_prices}
    
    # ตรวจสอบว่าการเรียงลำดับถูกต้องหรือไม่
    ${is_equal}=    Run Keyword And Return Status    Lists Should Be Equal    ${actual_prices}    ${sorted_expected}
    
    # บันทึกผลลัพธ์การตรวจสอบ
    Run Keyword If    ${is_equal}    Log    การเรียงลำดับราคาถูกต้อง
    Run Keyword If    not ${is_equal}    Log    การเรียงลำดับราคาไม่ถูกต้อง
    
    # ตรวจเทียบทีละรายการและบันทึกใน log
    FOR    ${index}    IN RANGE    0    ${actual_prices.__len__()}
        ${actual}=    Get From List    ${actual_prices}    ${index}
        ${expected}=    Get From List    ${sorted_expected}    ${index}
        ${status}=    Run Keyword And Return Status    Should Be Equal    ${actual}    ${expected}
        ${result}=    Set Variable If    ${status}    ถูกต้อง    ไม่ถูกต้อง
        Log    ตำแหน่งที่ ${index+1}: ${actual} == ${expected} : ${result}
    END
    
    # ยืนยันผลลัพธ์
    Lists Should Be Equal    ${actual_prices}    ${sorted_expected}

Validate Name Sorting
    [Arguments]    ${order}
    
    # ดึงชื่อสินค้าทั้งหมด
    @{name_elements}=    Get WebElements    css=.inventory_item_name
    @{actual_names}=    Create List
    
    # ดึงข้อมูลชื่อและบันทึกใน log
    Log    กำลังตรวจสอบการเรียงลำดับตามชื่อ (${order})
    
    FOR    ${index}    ${element}    IN ENUMERATE    @{name_elements}
        ${name_text}=    Get Text    ${element}
        Append To List    ${actual_names}    ${name_text}
        Log    สินค้าลำดับที่ ${index+1}: ${name_text}
    END
    
    # คัดลอกข้อมูลสำหรับการเรียงลำดับ
    ${sorted_names}=    Copy List    ${actual_names}
    
    # กรณีเรียงจากต่ำไปสูง (ascending)
    Run Keyword If    '${order}' == 'asc'    Sort List    ${sorted_names}
    
    # กรณีเรียงจากสูงไปต่ำ (descending)
    ${desc_list}=    Copy List    ${sorted_names}
    Run Keyword If    '${order}' == 'desc'    Sort List    ${desc_list}
    Run Keyword If    '${order}' == 'desc'    Reverse List    ${desc_list}
    Run Keyword If    '${order}' == 'desc'    Set Variable    ${sorted_names}    ${desc_list}
    
    # บันทึกข้อมูลการเปรียบเทียบใน log
    Log    ชื่อที่ควรเป็น: ${sorted_names}
    Log    ชื่อจริงบนเว็บ: ${actual_names}
    
    # ตรวจสอบว่าการเรียงลำดับถูกต้องหรือไม่
    ${is_equal}=    Run Keyword And Return Status    Lists Should Be Equal    ${actual_names}    ${sorted_names}
    
    # บันทึกผลลัพธ์การตรวจสอบ
    Run Keyword If    ${is_equal}    Log    การเรียงลำดับชื่อถูกต้อง
    Run Keyword If    not ${is_equal}    Log    การเรียงลำดับชื่อไม่ถูกต้อง
    
    # ตรวจเทียบทีละรายการและบันทึกใน log
    FOR    ${index}    IN RANGE    0    ${actual_names.__len__()}
        ${actual}=    Get From List    ${actual_names}    ${index}
        ${expected}=    Get From List    ${sorted_names}    ${index}
        ${status}=    Run Keyword And Return Status    Should Be Equal    ${actual}    ${expected}
        ${result}=    Set Variable If    ${status}    ถูกต้อง    ไม่ถูกต้อง
        Log    ตำแหน่งที่ ${index+1}: "${actual}" == "${expected}" : ${result}
    END
    
    # ยืนยันผลลัพธ์
    Lists Should Be Equal    ${actual_names}    ${sorted_names}

Validate Sidebar
    Click Element    css=.bm-burger-button
    Wait Until Element Is Visible    css=.bm-menu  timeout=10s
    ${is_visible}=    Run Keyword And Return Status    Element Should Be Visible    css=.bm-menu
    Run Keyword If    not ${is_visible}    Log    ไม่สามารถเปิด sidebar ได้
    Run Keyword If    ${is_visible}    Log    เปิด sidebar สำเร็จ

Select Product to Cart
    [Arguments]    ${product_name}
    Wait Until Element Is Visible    xpath=//div[contains(@class,'inventory_item_name') and normalize-space(text())='${product_name}']    timeout=5s
    Click Button    xpath=//div[contains(@class,'inventory_item')][.//div[contains(@class,'inventory_item_name') and normalize-space(text())='${product_name}']]//button[contains(@data-test, 'add-to-cart')]

Validate the display quantity in the basket
    # ตรวจสอบจำนวนปุ่ม Remove
    ${remove_buttons}=    Get WebElements    xpath=//button[contains(@data-test, 'remove')]
    
    # ดึงจำนวนสินค้าจาก .shopping_cart_badge
    ${actual_quantity}=    Get Text    css=.shopping_cart_badge
    
    # เปรียบเทียบจำนวนสินค้าจาก .shopping_cart_badge กับจำนวนที่นับจากปุ่ม Remove
    ${remove_button_count}=    Get Length    ${remove_buttons}
    Should Be Equal As Strings    ${actual_quantity}    ${remove_button_count}
    
    Log    จำนวนสินค้า: ${remove_button_count}, เลขจำนวนสินค้า: ${actual_quantity}

Validate Quantity Products in Cart and count Product icon
    # ตรวจสอบจำนวนสินค้าในตะกร้า
    ${quantity_icon}=    Get Text    css=.shopping_cart_badge

    ${cart_quantity}=    Get WebElements    css=.cart_quantity
    ${cart_quantity_count}=    Get Length    ${cart_quantity}
    Should Be Equal As Strings    ${cart_quantity_count}    ${quantity_icon}
    Log    จำนวนสินค้า: ${cart_quantity_count}
Remove Product 
    [Arguments]    ${product_name}
    Click Button    xpath=//div[contains(@class,'inventory_item')]//div[contains(@class,'inventory_item_name') and normalize-space(text())='${product_name}']//ancestor::div[contains(@class,'inventory_item_description')]//button[contains(@data-test, 'remove')]
Remove Product from Cart
    [Arguments]    ${product_name}
    Click Button    xpath=//div[contains(@class,'cart_item')][.//div[contains(@class,'inventory_item_name') and normalize-space(text())='${product_name}']]//button[contains(@data-test, 'remove')]

Go to Chackout page
    Select Product to Cart    Sauce Labs Bike Light
    Click element    css=.shopping_cart_link
    Click button       id=checkout
    
Fill the checkout Form
    [Arguments]    ${first_name}    ${last_name}    ${zip_code}
    Input Text    id=first-name    ${first_name}
    Input Text    id=last-name    ${last_name}
    Input Text    id=postal-code    ${zip_code}
    Click Button    id=continue

wait until it checks and display error messageInformation
    Wait Until Page Contains Element    ${Error_Message_Information}  timeout=10s
    

verify error messageInformation is correct
    [Arguments]    ${element_Information}    ${expected_messageInformation}
    Element Text Should Be    ${element_Information}    ${expected_messageInformation}

Check Price total and tex 
    ${ItemPrices}=    Get WebElements    xpath=//div[@class="inventory_item_price"]
    ${total_item_price}=    Set Variable    0

    # Loop through each item and add up the total price
    FOR    ${item_price_element}    IN    @{ItemPrices}
        ${item_price}=    Get Text    ${item_price_element}
        ${item_price}=    Evaluate    float('${item_price}'.replace('$', '').replace(',', ''))
        ${total_item_price}=    Evaluate    ${total_item_price} + ${item_price}
    END

    Log    Total Item Price (calculated): ${total_item_price}

    # Step 2: Get Item Total from the summary section (to compare)
    ${ItemTotal}=    Get Text    xpath=//div[@class='summary_subtotal_label']
    Log    Item Total (raw): ${ItemTotal}
    
    # Remove '$' and 'Item total: ' and convert to float
    ${ItemTotal}=    Evaluate    float('${ItemTotal}'.replace('Item total: $', '').replace(',', ''))
    Log    Item Total (converted to float): ${ItemTotal}

    # Step 3: Compare calculated total item price with the item total in summary
    Should Be Equal As Numbers    ${total_item_price}    ${ItemTotal}

    # Step 4: Get Tax from summary section (to compare)
    ${Tax}=    Get Text    xpath=//div[@class='summary_tax_label']
    Log    Tax (raw): ${Tax}
    
    # Remove '$' and 'Tax: ' and convert to float
    ${Tax}=    Evaluate    float('${Tax}'.replace('Tax: $', '').replace(',', ''))
    Log    Tax (converted to float): ${Tax}

    # Step 5: Compare calculated tax with the tax displayed in summary
    ${calculated_tax}=    Evaluate    round(${total_item_price} * 0.08, 2)
    Should Be Equal As Numbers    ${calculated_tax}    ${Tax}
    
    Log    Calculated Tax: ${calculated_tax}

    # Step 6: Calculate Total (Item Total + Tax)
    ${Total}=    Evaluate    round(${total_item_price} + ${Tax}, 2)
    Log    Total: ${Total}

    # Step 7: Get Total from summary and compare
    ${TotalSummary}=    Get Text    xpath=//div[@class='summary_total_label']
    Log    Total Summary (raw): ${TotalSummary}
    
    # Remove '$' and 'Total: ' and convert to float
    ${TotalSummary}=    Evaluate    float('${TotalSummary}'.replace('Total: $', '').replace(',', ''))
    Log    Total Summary (converted to float): ${TotalSummary}

    # Step 8: Compare calculated total with the total displayed in summary
    Should Be Equal As Numbers    ${Total}    ${TotalSummary}