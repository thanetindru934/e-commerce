*** Settings ***
Documentation    Automated Functional Testing for Shopping Cart and Guest Shopping
Resource         ecommerce_resources.robot
Suite Setup      Open E-Commerce Website
Suite Teardown   Close All Browsers
Test Setup       Start Fresh Guest Session

*** Variables ***
${T_SHIRT_URL}    ${BASE_URL}/products/t-shirt-6qp8/
${HAT_URL}        ${BASE_URL}/products/hat/
${EXPECTED_SUBTOTAL_TWO}    79.98
${EXPECTED_TOTAL_TWO}       86.38

*** Keywords ***
Start Fresh Guest Session
    Delete All Cookies
    Go To    ${BASE_URL}/
    Page Should Contain    Register
    Page Should Contain    Login

Add T-Shirt As Guest
    Go To    ${T_SHIRT_URL}
    ${already_in}=    Run Keyword And Return Status
    ...    Page Should Contain Button    Remove?
    IF    ${already_in}
        Click Button    Remove?
        Go To    ${T_SHIRT_URL}
    END
    Click Button    Add to Cart
    Page Should Contain    Cart

Add Hat As Guest
    Go To    ${HAT_URL}
    ${already_in}=    Run Keyword And Return Status
    ...    Page Should Contain Button    Remove?
    IF    ${already_in}
        Click Button    Remove?
        Go To    ${HAT_URL}
    END
    Click Button    Add to Cart
    Page Should Contain    Cart

Submit Guest Email
    [Arguments]    ${email}
    Input Text
    ...    xpath=//form[contains(@action,'/register/guest/')]//input[@name='email']
    ...    ${email}
    Click Button
    ...    xpath=//form[contains(@action,'/register/guest/')]//button[@type='submit']

*** Test Cases ***
Cart Count Updates After Add And Remove
    Add T-Shirt As Guest
    Page Should Contain Element
    ...    xpath=//span[contains(@class,'navbar-cart-count') and normalize-space(.)='1']
    Go To    ${T_SHIRT_URL}
    Click Button    Remove?
    Page Should Contain    Cart is empty
    Page Should Contain Element
    ...    xpath=//span[contains(@class,'navbar-cart-count') and normalize-space(.)='0']

Guest Cart Persists Across Navigation
    Add T-Shirt As Guest
    Go To    ${BASE_URL}/
    Go To    ${BASE_URL}/contact/
    Go To    ${BASE_URL}/products/
    Go To    ${BASE_URL}/cart/
    Page Should Contain    T-Shirt
    Page Should Contain Element
    ...    xpath=//span[contains(@class,'navbar-cart-count') and normalize-space(.)='1']

Removing One Item Keeps The Other Item
    Add T-Shirt As Guest
    Add Hat As Guest
    Go To    ${T_SHIRT_URL}
    Click Button    Remove?
    Page Should Contain    Hat
    Page Should Not Contain    T-Shirt
    Page Should Contain    39.99
    Page Should Contain Element
    ...    xpath=//span[contains(@class,'navbar-cart-count') and normalize-space(.)='1']



Verify Two Product Subtotal And Total
    Add T-Shirt As Guest
    Add Hat As Guest
    Go To    ${BASE_URL}/cart/
    Page Should Contain    ${EXPECTED_SUBTOTAL_TWO}
    Page Should Contain    ${EXPECTED_TOTAL_TWO}

Guest Checkout Shows Login And Guest Email Paths
    Add T-Shirt As Guest
    Go To    ${BASE_URL}/cart/checkout/
    Page Should Contain    Login
    Page Should Contain Element
    ...    xpath=//form[contains(@action,'/login/')]//input[@name='password']
    Page Should Contain Element
    ...    xpath=//form[contains(@action,'/register/guest/')]//input[@name='email']

Guest Email Advances To Shipping And Keeps Cart
    Add T-Shirt As Guest
    Go To    ${BASE_URL}/cart/checkout/
    Submit Guest Email    ${TEST_EMAIL}
    Wait Until Page Contains    Shipping Address    10 seconds
    Go To    ${BASE_URL}/cart/
    Page Should Contain    T-Shirt
    Go To    ${BASE_URL}/cart/checkout/
    Page Should Contain    Shipping Address

Guest Cart Persists After Registration And Login
    Add T-Shirt As Guest
    Register Test Customer
    Location Should Be    ${BASE_URL}/login/
    Login Test Customer
    Wait Until Page Contains    Logout    10 seconds
    Go To    ${BASE_URL}/cart/
    Page Should Contain    T-Shirt
    Page Should Contain Element
    ...    xpath=//span[contains(@class,'navbar-cart-count') and normalize-space(.)='1']

Fresh Guest Cart Opens Empty
    Go To    ${BASE_URL}/cart/
    Page Should Contain    Cart is empty

Single Product Cart Displays Correct Price
    Add T-Shirt As Guest
    Go To    ${BASE_URL}/cart/
    Page Should Contain    T-Shirt
    Page Should Contain    39.99

Guest Cart Persists After Page Refresh
    Add T-Shirt As Guest
    Go To    ${BASE_URL}/cart/
    Page Should Contain    T-Shirt
    Reload Page
    Wait Until Page Contains    T-Shirt    10 seconds
    Page Should Contain Element
    ...    xpath=//span[contains(@class,'navbar-cart-count') and normalize-space(.)='1']

Two Product Cart Survives Checkout Navigation
    Add T-Shirt As Guest
    Add Hat As Guest
    Go To    ${BASE_URL}/cart/checkout/
    Page Should Contain    Login
    Go To    ${BASE_URL}/cart/
    Page Should Contain    T-Shirt
    Page Should Contain    Hat

Invalid Guest Email Does Not Proceed To Shipping
    Add T-Shirt As Guest
    Go To    ${BASE_URL}/cart/checkout/
    Input Text
    ...    xpath=//form[contains(@action,'/register/guest/')]//input[@name='email']
    ...    invalid-email
    Click Button
    ...    xpath=//form[contains(@action,'/register/guest/')]//button[@type='submit']
    Location Should Contain    /register/
    Page Should Not Contain    Shipping Address

Empty Cart Checkout Does Not Show Shipping
    Go To    ${BASE_URL}/cart/checkout/
    Page Should Not Contain    Shipping Address

Empty Guest Email Does Not Proceed To Shipping
    Add T-Shirt As Guest
    Go To    ${BASE_URL}/cart/checkout/
    Click Button
    ...    xpath=//form[contains(@action,'/register/guest/')]//button[@type='submit']
    Location Should Contain    /cart/checkout/
    Page Should Not Contain    Shipping Address

Guest Cart Remains After Invalid Checkout Submission
    Add T-Shirt As Guest
    Go To    ${BASE_URL}/cart/checkout/
    Input Text
    ...    xpath=//form[contains(@action,'/register/guest/')]//input[@name='email']
    ...    invalid-email
    Click Button
    ...    xpath=//form[contains(@action,'/register/guest/')]//button[@type='submit']
    Go To    ${BASE_URL}/cart/
    Page Should Contain    T-Shirt


Invalid Guest Email Shows Validation Feedback
    Add T-Shirt As Guest
    Go To    ${BASE_URL}/cart/checkout/
    Input Text
    ...    xpath=//form[contains(@action,'/register/guest/')]//input[@name='email']
    ...    invalid-email
    Click Button
    ...    xpath=//form[contains(@action,'/register/guest/')]//button[@type='submit']
    Page Should Contain    Enter a valid email address.

Invalid Login Shows Authentication Error
    Go To    ${BASE_URL}/login/
    Input Text
    ...    xpath=//form[contains(@action,'/login/')]//input[@name='email']
    ...    invalid@example.com
    Input Text
    ...    xpath=//form[contains(@action,'/login/')]//input[@name='password']
    ...    WrongPassword123
    Click Button
    ...    xpath=//form[contains(@action,'/login/')]//button[@type='submit']
    Page Should Contain    Invalid email or password.

Mismatched Registration Passwords Show Validation Error
    Go To    ${BASE_URL}/register/
    Input Text
    ...    xpath=//form//input[@name='full_name']
    ...    Test Validation User
    Input Text
    ...    xpath=//form//input[@name='email']
    ...    ${TEST_EMAIL}
    Input Password
    ...    xpath=//form//input[@name='password1']
    ...    Password123
    Input Password
    ...    xpath=//form//input[@name='password2']
    ...    DifferentPassword456
    Click Button    Register
    Page Should Contain    Passwords don't match

Invalid Cart Product Update Gives User Feedback
    Go To    ${BASE_URL}/cart/
    Execute Javascript
    ...    var f=document.createElement('form');f.method='POST';f.action='/cart/update/';
    ...    var i=document.createElement('input');i.type='hidden';i.name='product_id';i.value='999999';
    ...    f.appendChild(i);document.body.appendChild(f);f.submit();
    Wait Until Location Contains    /cart/    10 seconds
    Page Should Contain    Product is gone?