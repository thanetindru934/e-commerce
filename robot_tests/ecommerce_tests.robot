*** Settings ***
Documentation    Automated Functional Testing for E-Commerce System
Resource         ecommerce_resources.robot
Suite Setup      Open E-Commerce Website
Suite Teardown   Close All Browsers


*** Test Cases ***

TC_REG_01 - Register With Valid Details
    [Documentation]    Verify registration using valid customer information.
    Register Test Customer
    Location Should Be    ${BASE_URL}/login/
    Page Should Contain    Login


TC_REG_02 - Register With Existing Email
    [Documentation]    Verify duplicate email registration is rejected.
    Go To Registration
    Input Text        id=id_full_name    Duplicate Customer
    Input Text        id=id_email        ${TEST_EMAIL}
    Input Password    id=id_password1    ${TEST_PASSWORD}
    Input Password    id=id_password2    ${TEST_PASSWORD}
    Click Button      Register
    Location Should Be    ${BASE_URL}/register/
    Page Should Contain    already exists


TC_REG_03 - Register With Empty Required Fields
    [Documentation]    Verify required registration fields are validated.
    Go To Registration
    Click Button    Register
    Location Should Be    ${BASE_URL}/register/
    Page Should Contain    Register


TC_LOGIN_01 - Login With Valid Credentials
    [Documentation]    Verify registered customer can login.
    Go To Login
    Input Text        id=id_email       ${TEST_EMAIL}
    Input Password    id=id_password    ${TEST_PASSWORD}
    Click Button      Login
    Wait Until Page Contains    Logout    10 seconds
    Page Should Contain    Logout


TC_LOGIN_02 - Login With Incorrect Password
    [Documentation]    Verify login is rejected for an incorrect password.
    Go To    ${BASE_URL}/logout/
    Go To Login
    Input Text        id=id_email       ${TEST_EMAIL}
    Input Password    id=id_password    WrongPassword123
    Click Button      Login
    Location Should Be    ${BASE_URL}/login/
    Page Should Contain    Login


TC_LOGIN_03 - Login With Unregistered Email
    [Documentation]    Verify an unregistered customer cannot login.
    Go To Login
    Input Text        id=id_email       nobody_robot@example.com
    Input Password    id=id_password    ${TEST_PASSWORD}
    Click Button      Login
    Location Should Be    ${BASE_URL}/login/
    Page Should Contain    Login


TC_LOGIN_04 - Login With Empty Fields
    [Documentation]    Verify required login fields are validated.
    Go To Login
    Click Button    Login
    Location Should Be    ${BASE_URL}/login/
    Page Should Contain    Login


TC_PROD_01 - Display Product List
    [Documentation]    Verify available products are displayed.
    Go To Products
    Page Should Contain    T-Shirt
    Page Should Contain    Hat
    Page Should Contain    SuperComputer


TC_PROD_02 - View Product Details
    [Documentation]    Verify product details are displayed correctly.
    Go To    ${BASE_URL}/products/t-shirt-6qp8/
    Page Should Contain    T-Shirt
    Page Should Contain    This is an awesome T Shirt
    Page Should Contain    Add to Cart


TC_PROD_03 - Verify Product Image
    [Documentation]    Verify the product image is displayed correctly.
    Go To    ${BASE_URL}/products/t-shirt-6qp8/
    Page Should Contain Element    xpath=//img[contains(@class,'img-fluid')]


TC_SEARCH_01 - Search Valid Product
    [Documentation]    Verify an existing product can be searched.
    Go To    ${BASE_URL}/search/
    Input Text      name=q    SuperComputer
    Click Button    Search
    Page Should Contain    Results for
    Page Should Contain    SuperComputer


TC_SEARCH_02 - Search Non-Existent Product
    [Documentation]    Verify search handles a product that does not exist.
    Go To    ${BASE_URL}/search/
    Input Text      name=q    RobotProductDoesNotExist999
    Click Button    Search

    Location Should Contain    /search/
    Page Should Not Contain    SuperComputer
    Page Should Not Contain    Server Error


TC_SEARCH_03 - Search With Empty Keyword
    [Documentation]    Verify an empty search does not cause an application error.
    Go To    ${BASE_URL}/search/
    Click Button    Search
    Page Should Not Contain    Server Error


TC_CART_01 - Add One Product To Cart
    [Documentation]    Verify a product can be added to the shopping cart.
    Add T-Shirt To Cart
    Go To Cart
    Page Should Contain    T-Shirt
    Page Should Contain    Subtotal


TC_CART_02 - Add Multiple Products
    [Documentation]    Verify multiple products can be added to the cart.
    Add Hat To Cart
    Go To Cart
    Page Should Contain    T-Shirt
    Page Should Contain    Hat


TC_CART_03 - Remove Product From Cart
    [Documentation]    Verify a product can be removed and the cart updates.
    Go To Cart
    Click Button    Remove?
    Page Should Contain    Cart


TC_CART_04 - Verify Cart Total
    [Documentation]    Verify the cart displays subtotal and total values.
    Add T-Shirt To Cart
    Go To Cart
    Page Should Contain    Subtotal
    Page Should Contain    Total
    Page Should Contain Element    xpath=//*[contains(text(),'Subtotal')]
    Page Should Contain Element    xpath=//*[contains(text(),'Total')]


TC_CHECK_01 - Checkout With Valid Information
    [Documentation]    Verify checkout proceeds with valid information.
    Login Test Customer

    Go To    ${BASE_URL}/products/t-shirt-6qp8/

    ${add_exists}=    Run Keyword And Return Status
    ...    Page Should Contain Button    Add to Cart

    IF    ${add_exists}
        Click Button    Add to Cart
    END

    Go To    ${BASE_URL}/cart/
    Page Should Contain    T-Shirt

    Go To    ${BASE_URL}/cart/checkout/
    Page Should Contain    Shipping Address

    Input Text    id=id_address_line_1    1 Robot Street
    Input Text    id=id_address_line_2    Test Building
    Input Text    id=id_city              Darwin
    Input Text    id=id_country           Australia
    Input Text    id=id_state             NT
    Input Text    id=id_postal_code       0800
    Click Button    Submit

    Page Should Contain    Billing Address

    Input Text    id=id_address_line_1    1 Robot Street
    Input Text    id=id_address_line_2    Test Building
    Input Text    id=id_city              Darwin
    Input Text    id=id_country           Australia
    Input Text    id=id_state             NT
    Input Text    id=id_postal_code       0800
    Click Button    Submit

    Page Should Contain    Finalize Checkout
    Click Button    Finalize Checkout
    Page Should Contain    Thank you for your order


TC_CHECK_02 - Checkout With Missing Required Information
    [Documentation]    Verify required checkout information is validated.

    Go To    ${BASE_URL}/products/t-shirt-6qp8/

    ${add_exists}=    Run Keyword And Return Status
    ...    Page Should Contain Button    Add to Cart

    IF    ${add_exists}
        Click Button    Add to Cart
    END

    Go To    ${BASE_URL}/cart/
    Page Should Contain    T-Shirt

    Go To    ${BASE_URL}/cart/checkout/
    Page Should Contain    Shipping Address

    Click Button    Submit

    Location Should Contain    /cart/checkout/
    Page Should Contain    Shipping Address

TC_CHECK_03 - Checkout With Empty Cart
    [Documentation]    Verify checkout cannot proceed with an empty cart.
    Go To    ${BASE_URL}/cart/

    ${remove}=    Run Keyword And Return Status
    ...    Page Should Contain Button    Remove?

    WHILE    ${remove}
        Click Button    Remove?
        Go To    ${BASE_URL}/cart/
        ${remove}=    Run Keyword And Return Status
        ...    Page Should Contain Button    Remove?
    END

    Go To    ${BASE_URL}/cart/checkout/
    Location Should Be    ${BASE_URL}/cart/
    Page Should Contain    Cart is empty


TC_ADMIN_01 - Admin Adds New Product
    [Documentation]    Verify an administrator can create a product.
    Delete All Cookies
    Go To    ${BASE_URL}/admin/

    Input Text        id=id_username    ${ADMIN_EMAIL}
    Input Password    id=id_password    ${ADMIN_PASSWORD}
    Click Button      Log in

    Go To    ${BASE_URL}/admin/products/product/add/

    Input Text        id=id_title          Robot Test Product
    Input Text        id=id_description    Product created by Robot Framework
    Input Text        id=id_price          25.00
    Select Checkbox   id=id_featured
    Select Checkbox   id=id_active
    Click Button      Save

    Go To    ${BASE_URL}/admin/products/product/
    Page Should Contain    Robot Test Product


TC_ADMIN_02 - Admin Edits Product
    [Documentation]    Verify an administrator can modify a product.
    Go To    ${BASE_URL}/admin/products/product/
    Click Link    Robot Test Product

    Clear Element Text    id=id_title
    Input Text            id=id_title    Robot Test Product Updated
    Click Button          Save

    Page Should Contain    Robot Test Product Updated


TC_ADMIN_03 - Admin Deletes Product
    [Documentation]    Verify an administrator can delete a product.
    Go To    ${BASE_URL}/admin/products/product/
    Click Link    Robot Test Product Updated
    Click Link    Delete
    Click Button    Yes, I’m sure

    Location Should Contain    /admin/products/product/
    Page Should Contain    was deleted successfully


TC_ADMIN_04 - Customer Attempts Admin Access
    [Documentation]    Verify a normal customer cannot access admin functionality.
    Delete All Cookies
    Go To    ${BASE_URL}/admin/products/product/

    Location Should Contain    /admin/login/
    Page Should Contain Element    id=id_username
    Page Should Contain Element    id=id_password
    Page Should Not Contain    Add product