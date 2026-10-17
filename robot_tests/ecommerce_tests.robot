*** Settings ***
Documentation    Consolidated E-Commerce Functional Testing
Resource         ecommerce_resources.robot
Suite Setup      Open E-Commerce Website
Suite Teardown   Close All Browsers


*** Keywords ***

Start Fresh Customer Session
    Delete All Cookies
    Login Test Customer

Prepare Customer Cart
    Start Fresh Customer Session
    Go To Cart
    ${present}=    Run Keyword And Return Status    Page Should Contain    T-Shirt
    IF    not ${present}
        Go To    ${BASE_URL}/products/t-shirt-6qp8/
        Wait Until Page Contains    T-Shirt    10s
        ${add}=    Run Keyword And Return Status    Page Should Contain Button    Add to Cart
        IF    ${add}
            Click Button    Add to Cart
        ELSE
            Page Should Contain Button    Remove?
        END
    END
    Go To Cart
    Wait Until Page Contains    T-Shirt    10s

Prepare Guest Cart
    Delete All Cookies
    Add T-Shirt To Cart
    Go To Cart
    Wait Until Page Contains    T-Shirt    10s

Fill Checkout Address
    [Arguments]    ${street}=1 Robot Street    ${unit}=Test Building
    Input Text    id=id_address_line_1    ${street}
    Input Text    id=id_address_line_2    ${unit}
    Input Text    id=id_city    Darwin
    Input Text    id=id_country    Australia
    Input Text    id=id_state    NT
    Input Text    id=id_postal_code    0800

Submit Shipping Address
    Wait Until Page Contains    Shipping Address    10s
    Fill Checkout Address
    Click Button    Submit
    Wait Until Page Contains    Billing Address    10s

Submit Billing Address
    Wait Until Page Contains    Billing Address    10s
    Fill Checkout Address
    Click Button    Submit
    Wait Until Page Contains    Finalize Checkout    10s

Login To Admin
    Delete All Cookies
    Go To    ${BASE_URL}/admin/
    Wait Until Page Contains Element    id=id_username    10s
    Input Text    id=id_username    ${ADMIN_EMAIL}
    Input Password    id=id_password    ${ADMIN_PASSWORD}
    Click Button    Log in
    Wait Until Page Contains    Site administration    10s

Create Admin Product
    [Arguments]    ${title}    ${price}=25.00    ${active}=${TRUE}
    Go To    ${BASE_URL}/admin/products/product/add/
    Wait Until Page Contains Element    id=id_title    10s
    Input Text    id=id_title    ${title}
    Input Text    id=id_description    Product created for Robot Framework testing
    Input Text    id=id_price    ${price}
    IF    ${active}
        Select Checkbox    id=id_active
    ELSE
        Unselect Checkbox    id=id_active
    END
    Click Button    Save
    Wait Until Page Contains    ${title}    10s

Edit Admin Product Price
    [Arguments]    ${title}    ${price}
    Go To    ${BASE_URL}/admin/products/product/
    Wait Until Page Contains    ${title}    10s
    Click Link    ${title}
    Wait Until Page Contains Element    id=id_price    10s
    Clear Element Text    id=id_price
    Input Text    id=id_price    ${price}
    Click Button    Save
    Wait Until Page Contains Element    css:ul.messagelist li.success    10s

Search And Open Product
    [Arguments]    ${title}
    Go To    ${BASE_URL}/search/
    Input Text    name=q    ${title}
    Click Button    Search
    Wait Until Page Contains    ${title}    10s
    Click Link    View
    Wait Until Page Contains    ${title}    10s

*** Test Cases ***

# ============================================================
# REGISTRATION TESTS (13)
# ============================================================

TC_REG_01 - Register With Valid Details
    [Documentation]    Verify registration succeeds using valid customer information.
    Register Test Customer
    Location Should Be    ${BASE_URL}/login/
    Page Should Contain    Login

TC_REG_02 - Register With Existing Email
    [Documentation]    Verify registration is rejected when the email already exists.
    Go To Registration
    Input Text        id=id_full_name    Duplicate Customer
    Input Text        id=id_email        ${TEST_EMAIL}
    Input Password    id=id_password1    ${TEST_PASSWORD}
    Input Password    id=id_password2    ${TEST_PASSWORD}
    Click Button      Register
    Location Should Be    ${BASE_URL}/register/
    Page Should Contain    already exists

TC_REG_03 - Register With All Fields Empty
    [Documentation]    Verify registration is rejected when all required fields are empty.
    Go To Registration
    Click Button    Register
    Location Should Be    ${BASE_URL}/register/
    Page Should Contain    Register

TC_REG_04 - Register With Empty Full Name
    [Documentation]    Verify registration is rejected when full name is empty.
    Go To Registration
    Input Text        id=id_email        noname_robot@example.com
    Input Password    id=id_password1    ${TEST_PASSWORD}
    Input Password    id=id_password2    ${TEST_PASSWORD}
    Click Button      Register
    Location Should Be    ${BASE_URL}/register/
    Page Should Contain    Register

TC_REG_05 - Register With Empty Email
    [Documentation]    Verify registration is rejected when email is empty.
    Go To Registration
    Input Text        id=id_full_name    Empty Email Customer
    Input Password    id=id_password1    ${TEST_PASSWORD}
    Input Password    id=id_password2    ${TEST_PASSWORD}
    Click Button      Register
    Location Should Be    ${BASE_URL}/register/
    Page Should Contain    Register

TC_REG_06 - Register With Empty Password
    [Documentation]    Verify registration is rejected when the password is empty.
    Go To Registration
    Input Text        id=id_full_name    Empty Password Customer
    Input Text        id=id_email        emptypassword_robot@example.com
    Input Password    id=id_password2    ${TEST_PASSWORD}
    Click Button      Register
    Location Should Be    ${BASE_URL}/register/
    Page Should Contain    Register

TC_REG_07 - Register With Empty Confirm Password
    [Documentation]    Verify registration is rejected when confirmation password is empty.
    Go To Registration
    Input Text        id=id_full_name    Empty Confirm Customer
    Input Text        id=id_email        emptyconfirm_robot@example.com
    Input Password    id=id_password1    ${TEST_PASSWORD}
    Click Button      Register
    Location Should Be    ${BASE_URL}/register/
    Page Should Contain    Register

TC_REG_08 - Register With Mismatched Passwords
    [Documentation]    Verify registration is rejected when passwords do not match.
    Go To Registration
    Input Text        id=id_full_name    Mismatch Customer
    Input Text        id=id_email        mismatch_robot@example.com
    Input Password    id=id_password1    ${TEST_PASSWORD}
    Input Password    id=id_password2    DifferentPassword@123
    Click Button      Register
    Location Should Be    ${BASE_URL}/register/
    Page Should Contain    Register

TC_REG_09 - Register With Invalid Email Format
    [Documentation]    Verify registration is rejected when an invalid email format is entered.
    Go To Registration
    Input Text        id=id_full_name    Invalid Email Customer
    Input Text        id=id_email        invalid-email-format
    Input Password    id=id_password1    ${TEST_PASSWORD}
    Input Password    id=id_password2    ${TEST_PASSWORD}
    Click Button      Register
    Location Should Be    ${BASE_URL}/register/
    Page Should Contain    Register

TC_REG_10 - Register With Spaces Around Email
    [Documentation]    Verify the registration system safely handles leading and trailing spaces in an email.
    Go To Registration
    Input Text        id=id_full_name    Space Email Customer
    Input Text        id=id_email        ${SPACE}spaceemail_robot@example.com${SPACE}
    Input Password    id=id_password1    ${TEST_PASSWORD}
    Input Password    id=id_password2    ${TEST_PASSWORD}
    Click Button      Register
    Page Should Not Contain    Server Error

TC_REG_11 - Registration Page Displays Required Fields
    [Documentation]    Verify Registration Page Displays Required Fields.
    Go To Registration
    Page Should Contain Element    id=id_full_name
    Page Should Contain Element    id=id_email
    Page Should Contain Element    id=id_password1
    Page Should Contain Element    id=id_password2

TC_REG_12 - Registration Password Fields Are Masked
    [Documentation]    Verify Registration Password Fields Are Masked.
    Go To Registration
    Element Attribute Value Should Be    id=id_password1    type    password
    Element Attribute Value Should Be    id=id_password2    type    password

TC_REG_13 - Registration Email Field Is Available
    [Documentation]    Verify Registration Email Field Is Available.
    Go To Registration
    Element Should Be Visible    id=id_email
    Element Should Be Enabled    id=id_email


# ============================================================
# LOGIN TESTS (10)
# ============================================================

TC_LOGIN_01 - Valid Username And Valid Password
    [Documentation]    Verify login succeeds with valid username and valid password.
    Go To Login
    Input Text        id=id_email       ${TEST_EMAIL}
    Input Password    id=id_password    ${TEST_PASSWORD}
    Click Button      Login
    Wait Until Page Contains    Logout    10 seconds
    Page Should Contain    Logout

TC_LOGIN_02 - Invalid Username And Valid Password
    [Documentation]    Verify login fails with invalid username and valid password.
    Go To    ${BASE_URL}/logout/
    Go To Login
    Input Text        id=id_email       invalid_robot@example.com
    Input Password    id=id_password    ${TEST_PASSWORD}
    Click Button      Login
    Location Should Be    ${BASE_URL}/login/
    Page Should Contain    Login

TC_LOGIN_03 - Valid Username And Invalid Password
    [Documentation]    Verify login fails with valid username and invalid password.
    Go To Login
    Input Text        id=id_email       ${TEST_EMAIL}
    Input Password    id=id_password    WrongPassword123
    Click Button      Login
    Location Should Be    ${BASE_URL}/login/
    Page Should Contain    Login

TC_LOGIN_04 - Invalid Username And Invalid Password
    [Documentation]    Verify login fails with invalid username and invalid password.
    Go To Login
    Input Text        id=id_email       invalid_robot@example.com
    Input Password    id=id_password    WrongPassword123
    Click Button      Login
    Location Should Be    ${BASE_URL}/login/
    Page Should Contain    Login

TC_LOGIN_05 - Empty Username And Valid Password
    [Documentation]    Verify login fails with empty username and valid password.
    Go To Login
    Input Password    id=id_password    ${TEST_PASSWORD}
    Click Button      Login
    Location Should Be    ${BASE_URL}/login/
    Page Should Contain    Login

TC_LOGIN_06 - Valid Username And Empty Password
    [Documentation]    Verify login fails with valid username and empty password.
    Go To Login
    Input Text        id=id_email       ${TEST_EMAIL}
    Click Button      Login
    Location Should Be    ${BASE_URL}/login/
    Page Should Contain    Login

TC_LOGIN_07 - Empty Username And Empty Password
    [Documentation]    Verify login fails when both username and password are empty.
    Go To Login
    Click Button      Login
    Location Should Be    ${BASE_URL}/login/
    Page Should Contain    Login

TC_LOGIN_08 - Login Page Displays Credential Fields
    [Documentation]    Verify Login Page Displays Credential Fields.
    Go To Login
    Page Should Contain Element    id=id_email
    Page Should Contain Element    id=id_password

TC_LOGIN_09 - Login Password Field Is Masked
    [Documentation]    Verify Login Password Field Is Masked.
    Go To Login
    Element Attribute Value Should Be    id=id_password    type    password

TC_LOGIN_10 - Login Page Contains Submit Button
    [Documentation]    Verify Login Page Contains Submit Button.
    Go To Login
    Page Should Contain Button    Login


# ============================================================
# LOGOUT TESTS (2)
# ============================================================

TC_LOGOUT_01 - Logout Logged In Customer
    [Documentation]    Verify a logged-in customer can successfully logout.
    Go To Login
    Input Text        id=id_email       ${TEST_EMAIL}
    Input Password    id=id_password    ${TEST_PASSWORD}
    Click Button      Login

    Wait Until Page Contains    Logout    10 seconds
    Page Should Contain    Logout

    Click Link    Logout

    Location Should Contain    /login/
    Page Should Contain    Login
    Page Should Not Contain    Logout

TC_LOGOUT_02 - Logout Link Is Hidden On Login Page
    [Documentation]    Verify Logout Link Is Hidden On Login Page.
    Delete All Cookies
    Go To Login
    Page Should Not Contain    Logout


# ============================================================
# CONTACT FORM TESTS (8)
# ============================================================

TC_CONTACT_01 - Contact Form Page Loads
    [Documentation]    Verify the Contact Us page loads successfully.
    Go To    ${BASE_URL}/contact/
    Page Should Contain    Contact Us
    Page Should Contain    Send Us a Message
    Page Should Contain    Send Message

TC_CONTACT_02 - Submit Contact Form With Empty Fields
    [Documentation]    Verify empty required fields are rejected.
    Go To    ${BASE_URL}/contact/
    Click Button    Send Message
    Location Should Contain    /contact/
    Page Should Contain    Send Message

TC_CONTACT_03 - Submit Contact Form With Invalid Email
    [Documentation]    Verify an invalid email address is rejected.
    Go To    ${BASE_URL}/contact/
    Input Text    xpath=//input[@placeholder="Your Name"]    Robot Test Customer
    Input Text    xpath=//input[@placeholder="Your Email"]    invalid-email
    Input Text    xpath=//textarea[@placeholder="Your Content"]    Testing invalid email validation.
    Click Button    Send Message
    Location Should Contain    /contact/

TC_CONTACT_04 - Submit Contact Form With Empty Message
    [Documentation]    Verify a message is required.
    Go To    ${BASE_URL}/contact/
    Input Text    xpath=//input[@placeholder="Your Name"]    Robot Test Customer
    Input Text    xpath=//input[@placeholder="Your Email"]    robotcontact@example.com
    Click Button    Send Message
    Location Should Contain    /contact/
    Page Should Contain    Send Message

TC_CONTACT_05 - Contact Form Displays Name Field
    [Documentation]    Verify Contact Form Displays Name Field.
    Go To    ${BASE_URL}/contact/
    Page Should Contain Element    xpath=//input[@placeholder="Your Name"]

TC_CONTACT_06 - Contact Form Displays Email Field
    [Documentation]    Verify Contact Form Displays Email Field.
    Go To    ${BASE_URL}/contact/
    Page Should Contain Element    xpath=//input[@placeholder="Your Email"]

TC_CONTACT_07 - Contact Form Displays Message Field
    [Documentation]    Verify Contact Form Displays Message Field.
    Go To    ${BASE_URL}/contact/
    Page Should Contain Element    xpath=//textarea[@placeholder="Your Content"]

TC_CONTACT_08 - Contact Form Displays Send Button
    [Documentation]    Verify Contact Form Displays Send Button.
    Go To    ${BASE_URL}/contact/
    Page Should Contain Button    Send Message


# ============================================================
# PRODUCT TESTS (6)
# ============================================================

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

TC_PROD_04 - Product Detail Shows Product Title
    [Documentation]    Verify Product Detail Shows Product Title.
    Go To    ${BASE_URL}/products/t-shirt-6qp8/
    Page Should Contain    T-Shirt

TC_PROD_05 - Product Detail Shows Add To Cart Button
    [Documentation]    Verify Product Detail Shows Add To Cart Button.
    Go To    ${BASE_URL}/products/t-shirt-6qp8/
    Page Should Contain Button    Add to Cart

TC_PROD_06 - Products Page Contains Hat
    [Documentation]    Verify Products Page Contains Hat.
    Go To Products
    Page Should Contain    Hat


# ============================================================
# SEARCH TESTS (6)
# ============================================================

TC_SEARCH_01 - Search Valid Product
    [Documentation]    Verify an existing product is returned by search.
    Go To    ${BASE_URL}/search/
    Input Text    name=q    SuperComputer
    Click Button    Search
    Wait Until Page Contains    SuperComputer    10s
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

TC_SEARCH_04 - Search Page Displays Search Input
    [Documentation]    Verify Search Page Displays Search Input.
    Go To    ${BASE_URL}/search/
    Page Should Contain Element    name=q

TC_SEARCH_05 - Search Page Displays Search Button
    [Documentation]    Verify Search Page Displays Search Button.
    Go To    ${BASE_URL}/search/
    Page Should Contain Button    Search

TC_SEARCH_06 - Search Returns T Shirt Product
    [Documentation]    Verify Search Returns T Shirt Product.
    Go To    ${BASE_URL}/search/
    Input Text    name=q    T-Shirt
    Click Button    Search
    Page Should Contain    T-Shirt


# ============================================================
# CART TESTS (7)
# ============================================================

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

TC_CART_05 - Cart Page Loads Without Server Error
    [Documentation]    Verify Cart Page Loads Without Server Error.
    Go To Cart
    Page Should Not Contain    Server Error

TC_CART_06 - Cart Shows Added Hat
    [Documentation]    Verify Cart Shows Added Hat.
    Add Hat To Cart
    Go To Cart
    Page Should Contain    Hat

TC_CART_07 - Cart Shows Subtotal After Adding Hat
    [Documentation]    Verify Cart Shows Subtotal After Adding Hat.
    Add Hat To Cart
    Go To Cart
    Page Should Contain    Subtotal


# ============================================================
# CHECKOUT TESTS (14)
# ============================================================

TC_CHECK_01 - Checkout With Valid Information
    [Documentation]    Verify successful checkout with valid details.
    Prepare Customer Cart
    Go To    ${BASE_URL}/cart/checkout/
    Submit Shipping Address
    Submit Billing Address
    Click Button    Finalize Checkout
    Wait Until Page Contains    Thank you    10s

TC_CHECK_02 - Checkout With Missing Required Information
    [Documentation]    Verify shipping details are required.
    Prepare Customer Cart
    Go To    ${BASE_URL}/cart/checkout/
    Wait Until Page Contains    Shipping Address    10s
    Click Button    Submit
    Location Should Contain    /cart/checkout/
    Page Should Contain    Shipping Address

TC_CHECK_03 - Checkout With Empty Cart
    [Documentation]    Verify checkout rejects an empty cart.
    Delete All Cookies
    Login Test Customer
    Go To Cart
    ${remove}=    Run Keyword And Return Status    Page Should Contain Button    Remove?
    WHILE    ${remove}
        Click Button    Remove?
        Go To Cart
        ${remove}=    Run Keyword And Return Status    Page Should Contain Button    Remove?
    END
    Go To    ${BASE_URL}/cart/checkout/
    Location Should Be    ${BASE_URL}/cart/
    Page Should Contain    Cart is empty

TC_CHECK_04 - Verify Order Total
    [Documentation]    Verify displayed checkout totals.
    Prepare Customer Cart
    Page Should Contain    43.19
    Go To    ${BASE_URL}/cart/checkout/
    Submit Shipping Address
    Submit Billing Address
    Page Should Contain    Cart Total
    Page Should Contain    43.19
    Page Should Contain    Shipping Total
    Page Should Contain    5.99
    Page Should Contain    Order Total
    Page Should Contain    49.18

TC_CHECK_05 - Checkout With Missing Billing Details
    [Documentation]    Verify billing details are required.
    Prepare Customer Cart
    Go To    ${BASE_URL}/cart/checkout/
    Submit Shipping Address
    Click Button    Submit
    Location Should Contain    /cart/checkout/
    Page Should Contain    Billing Address

TC_CHECK_06 - Checked if different shipping and billing addresses are stored seperately
    [Documentation]    Verify separate addresses appear in checkout.
    Prepare Customer Cart
    Go To    ${BASE_URL}/cart/checkout/
    Wait Until Page Contains    Shipping Address    10s
    Fill Checkout Address    1 Robot Street    Test Unit
    Click Button    Submit
    Wait Until Page Contains    Billing Address    10s
    Fill Checkout Address    2 Billing Street    Test2 Unit
    Click Button    Submit
    Wait Until Page Contains    Finalize Checkout    10s
    Page Should Contain    1 Robot Street
    Page Should Contain    2 Billing Street

TC_CHECK_07 - Checking if the cart is empty after checkout
    [Documentation]    Verify completed checkout empties the cart.
    Prepare Customer Cart
    Go To    ${BASE_URL}/cart/checkout/
    Submit Shipping Address
    Submit Billing Address
    Click Button    Finalize Checkout
    Wait Until Page Contains    Thank you    10s
    Go To Cart
    Wait Until Page Contains    Cart is empty    10s

TC_CHECK_08 - Checking if saved addressed can be reused
    [Documentation]    Verify saved shipping address appears at billing step.
    Prepare Customer Cart
    Go To    ${BASE_URL}/cart/checkout/
    Wait Until Page Contains    Shipping Address    10s
    Fill Checkout Address    199 Robot Street    Saved Address Unit
    Click Button    Submit
    Wait Until Page Contains    Billing Address    10s
    Page Should Contain    199 Robot Street

TC_CHECK_09 - Checking login from checkout
    [Documentation]    Verify guest can log in during checkout.
    Prepare Guest Cart
    Go To    ${BASE_URL}/cart/checkout/
    Wait Until Page Contains    Login    10s
    Page Should Contain Element    id=id_email
    Page Should Contain Element    id=id_password
    Input Text    id=id_email    ${TEST_EMAIL}
    Input Password    id=id_password    ${TEST_PASSWORD}
    Click Button    Login
    Wait Until Page Contains    Shipping Address    10s
    Location Should Contain    /cart/checkout/

TC_CHECK_10 - Checks If Guest Checkout Option Is Shown
    [Documentation]    Verify guest checkout form exists on checkout page.
    Prepare Guest Cart
    Go To    ${BASE_URL}/cart/checkout/
    Wait Until Page Contains    Login    10s
    Page Should Contain Element    xpath://form[contains(@action, 'guest')]

TC_CHECK_11 - Checking an Invalid Order Can Be Completed
    [Documentation]    Verify a negative-price order cannot complete.
    Login To Admin
    Create Admin Product    Robot Invalid Order Test    -20.00
    Start Fresh Customer Session
    Go To    ${BASE_URL}/products/robot-invalid-order-test/
    Wait Until Page Contains    Robot Invalid Order Test    10s
    Click Button    Add to Cart
    Go To Cart
    Page Should Contain    Robot Invalid Order Test
    Go To    ${BASE_URL}/cart/checkout/
    Submit Shipping Address
    Submit Billing Address
    Click Button    Finalize Checkout
    Page Should Not Contain    Thank you for your order

TC_CHECK_12 - Checkout Requires Shipping Address
    [Documentation]    Verify shipping address section is displayed.
    Prepare Customer Cart
    Go To    ${BASE_URL}/cart/checkout/
    Wait Until Page Contains    Shipping Address    10s

TC_CHECK_13 - Checkout Shipping Address Has City Field
    [Documentation]    Verify city input is available.
    Prepare Customer Cart
    Go To    ${BASE_URL}/cart/checkout/
    Wait Until Page Contains    Shipping Address    10s
    Page Should Contain Element    id=id_city

TC_CHECK_14 - Checkout Shipping Address Has Postal Code Field
    [Documentation]    Verify postal code input is available.
    Prepare Customer Cart
    Go To    ${BASE_URL}/cart/checkout/
    Wait Until Page Contains    Shipping Address    10s
    Page Should Contain Element    id=id_postal_code

TC_ADMIN_01 - Admin Adds New Product
    [Documentation]    Verify an administrator can create a product.

    Delete All Cookies
    Go To    ${BASE_URL}/admin/

    Wait Until Page Contains Element    id=id_username    5s
    Wait Until Page Contains Element    id=id_password    5s

    Input Text        id=id_username    ${ADMIN_EMAIL}
    Input Password    id=id_password    ${ADMIN_PASSWORD}
    Click Button      Log in

    Wait Until Page Contains    Site administration    5s

    Go To    ${BASE_URL}/admin/products/product/add/

    Wait Until Page Contains Element    id=id_title    5s

    Input Text        id=id_title          Robot Test Product
    Input Text        id=id_description    Product created by Robot Framework
    Input Text        id=id_price          25.00
    Select Checkbox   id=id_featured
    Select Checkbox   id=id_active
    Click Button      Save

    Wait Until Page Contains    Robot Test Product    5s

TC_ADMIN_02 - Verify if the added product is visible
    [Documentation]    Verify if the new product is visible to customers

    Go To    ${BASE_URL}/products/
    Wait Until Page Contains    Robot Test Product    5s
    Page Should Contain    Robot Test Product

TC_ADMIN_03 - Admin Edits Product
    [Documentation]    Verify an administrator can modify a product.
    Go To    ${BASE_URL}/admin/products/product/
    Wait Until Page Contains    Robot Test Product    5s
    Click Link    Robot Test Product

    Wait Until Page Contains Element    id=id_title    5s
    Clear Element Text    id=id_title
    Input Text            id=id_title    Robot Test Product Updated
    Click Button          Save

    Wait Until Page Contains Element    css:ul.messagelist li.success    5s
    Element Should Contain    css:ul.messagelist li.success    changed successfully
    Wait Until Page Contains    Robot Test Product Updated    5s

TC_ADMIN_04 - Check Updated Product on Website
    [Documentation]    Verify the updated product info is visible on the website
    Go To    ${BASE_URL}/products/
    Page Should Contain     Robot Test Product Updated

TC_ADMIN_05 - Admin Changes Product Price
    [Documentation]    Verify an administrator can change the price of an existing product.
    Go To    ${BASE_URL}/admin/products/product/
    Wait Until Page Contains    Robot Test Product Updated    5s
    Click Link    Robot Test Product Updated

    Wait Until Page Contains Element    id=id_price    5s
    Clear Element Text    id=id_price
    Input Text            id=id_price    40.00
    Click Button          Save

    Wait Until Page Contains Element    css:ul.messagelist li.success    5s
    Element Should Contain    css:ul.messagelist li.success    changed successfully
    Wait Until Page Contains    Robot Test Product Updated    5s

TC_ADMIN_06 - Checks Updated Product has the changed price
    [Documentation]    Verify the updated product price is visible on the website
    Go To    ${BASE_URL}/search/
    Input Text    name=q     Robot Test Product Updated
    Click Button    Search

    Wait Until Page Contains    Robot Test Product Updated    5s
    Click Link    View

    Wait Until Page Contains    Robot Test Product Updated    5s
    Page Should Contain    Robot Test Product Updated

    Click Button    Add to Cart

    Go To    ${BASE_URL}/cart/
    Wait Until Page Contains    Robot Test Product Updated    5s
    Page Should Contain    Robot Test Product Updated
    Page Should Contain    40.00

TC_ADMIN_07 - Admin Deletes Product
    [Documentation]    Verify an administrator can delete a product.
    Go To    ${BASE_URL}/admin/products/product/

    Wait Until Page Contains    Robot Test Product Updated    5s
    Click Link    Robot Test Product Updated
    Wait Until Page Contains    Delete    5s
    Click Link    Delete
    Click Button    Yes, I’m sure

    Location Should Contain    /admin/products/product/
    Wait Until Page Contains Element    css:ul.messagelist li.success    5s
    Element Should Contain    css:ul.messagelist li.success    deleted successfully

TC_ADMIN_08 - Check if Deleted Product is removed from customer website
    [Documentation]    Verify that a product is completely removed from the customer side

    Go to    ${BASE_URL}/products/
    Wait Until Page Contains    Product    5s
    Page Should Not Contain    Robot Test Product Updated

TC_ADMIN_09 - Customer Attempts Admin Access
    [Documentation]    Verify a normal customer cannot access admin functionality.
    Delete All Cookies
    Go To    ${BASE_URL}/admin/products/product/

    Location Should Contain    /admin/login/
    Page Should Contain Element    id=id_username
    Page Should Contain Element    id=id_password
    Page Should Not Contain    Add product

TC_ADMIN_10 - Logged in Customer Attempts Admin Access
    [Documentation]    Verify if a logged in customer attempts admin access
    Delete All Cookies
    Login Test Customer

    Wait Until Page Contains    Logout    5s
    Go To    ${BASE_URL}/admin/products/product/

    Location Should Contain    /admin/login/
    Page Should Contain Element    id=id_username
    Page Should Contain Element    id=id_password
    Page Should Not Contain    Add product

TC_ADMIN_11 - Admin Adds New Product with blank fields
    [Documentation]    Verify if a product is not created if fields are blank.

    Delete All Cookies
    Go To    ${BASE_URL}/admin/

    Wait Until Page Contains Element    id=id_username    5s
    Wait Until Page Contains Element    id=id_password    5s

    Input Text        id=id_username    ${ADMIN_EMAIL}
    Input Password    id=id_password    ${ADMIN_PASSWORD}
    Click Button      Log in

    Wait Until Page Contains    Site administration    5s

    Go To    ${BASE_URL}/admin/products/product/add/

    Wait Until Page Contains Element    id=id_title    5s

    Click Button      Save

    Location Should Contain    /admin/products/product/add/
    Page Should Contain Element    id=id_title
    Page Should Contain Element    id=id_description

TC_ADMIN_12 - Checking if an inactive product is not visible in customer website
    [Documentation]    Verify if an inactive product is not visible in the website

    Delete All Cookies
    Go To    ${BASE_URL}/admin/

    Wait Until Page Contains Element    id=id_username    5s
    Wait Until Page Contains Element    id=id_password    5s

    Input Text        id=id_username    ${ADMIN_EMAIL}
    Input Password    id=id_password    ${ADMIN_PASSWORD}
    Click Button      Log in

    Wait Until Page Contains    Site administration    5s

    Go To    ${BASE_URL}/admin/products/product/add/

    Wait Until Page Contains Element    id=id_title    5s

    Input Text        id=id_title          Robot Test Inactive Product
    Input Text        id=id_description    Inactive Product Created
    Input Text        id=id_price          35.00

    Click Button      Save

    Wait Until Page Contains    Robot Test Inactive Product    5s

    Go To    ${BASE_URL}/products/
    Wait Until Page Contains    Products    5s
    Page Should Not Contain    Robot Test Inactive Product

TC_ADMIN_13 - Admin Adds a Negative Priced Product
    [Documentation]    Checks if the admin product rejects a negatvie valued product

    Delete All Cookies
    Go To    ${BASE_URL}/admin/

    Wait Until Page Contains Element    id=id_username    5s
    Wait Until Page Contains Element    id=id_password    5s

    Input Text    id=id_username    ${ADMIN_EMAIL}
    Input Password    id=id_password    ${ADMIN_PASSWORD}
    Click Button    Log in

    Wait Until Page Contains    Site administration    5s

    Go To    ${BASE_URL}/admin/products/product/add/
    Wait Until Page Contains Element    id=id_title    5s

    Input Text        id=id_title          Negative Price Test
    Input Text        id=id_description    Product used to test negative price
    Input Text        id=id_price          -20.00
    Select Checkbox    id=id_active
    Click Button    Save

    Wait Until Page Contains    Negative Price Test    5s

    Delete All Cookies
    Login Test Customer
    Wait Until Page Contains    Logout    5s

    Go To    ${BASE_URL}/products/negative-price-test/
    Wait Until Page Contains    Negative Price Test    5s
    Click Button    Add to Cart

    Go To    ${BASE_URL}/cart/
    Wait Until Page Contains    Negative Price Test    5s

    Page Should Not Contain    -20.00

TC_ADMIN_14 - Product Price change updates the existing cart
    [Documentation]    Verify an existing cart is changed when admin changes a product price.

    Delete All Cookies
    Go To    ${BASE_URL}/admin/

    Wait Until Page Contains Element    id=id_username    5s
    Wait Until Page Contains Element    id=id_password    5s

    Input Text        id=id_username    ${ADMIN_EMAIL}
    Input Password    id=id_password    ${ADMIN_PASSWORD}
    Click Button      Log in

    Wait Until Page Contains    Site administration    5s

    Go To    ${BASE_URL}/admin/products/product/add/
    Wait Until Page Contains Element    id=id_title    5s

    Input Text        id=id_title          Robot Cart Price Test
    Input Text        id=id_description    Product used to test cart price update
    Input Text        id=id_price          25.00
    Select Checkbox   id=id_active
    Click Button      Save

    Wait Until Page Contains    Robot Cart Price Test    5s

    Delete All Cookies

    Go To    ${BASE_URL}/search/
    Input Text    name=q    Robot Cart Price Test
    Click Button    Search

    Wait Until Page Contains    Robot Cart Price Test    5s
    Click Link    View

    Wait Until Page Contains    Robot Cart Price Test    5s
    Click Button    Add to Cart

    Go To    ${BASE_URL}/cart/
    Wait Until Page Contains    Robot Cart Price Test    5s
    Page Should Contain    25.00
    Page Should Contain    27.00

    Go To    ${BASE_URL}/admin/

    Wait Until Page Contains Element    id=id_username    5s
    Wait Until Page Contains Element    id=id_password    5s

    Input Text        id=id_username    ${ADMIN_EMAIL}
    Input Password    id=id_password    ${ADMIN_PASSWORD}
    Click Button      Log in

    Wait Until Page Contains    Site administration    5s

    Go To    ${BASE_URL}/admin/products/product/
    Wait Until Page Contains    Robot Cart Price Test    5s
    Click Link    Robot Cart Price Test

    Wait Until Page Contains Element    id=id_price    5s
    Clear Element Text    id=id_price
    Input Text    id=id_price    40.00
    Click Button    Save

    Wait Until Page Contains Element    css:ul.messagelist li.success    5s

    Go To    ${BASE_URL}/cart/
    Wait Until Page Contains    Robot Cart Price Test    5s

    Page Should Contain    40.00
    Page Should Contain    43.20

TC_ADMIN_15 - Updated Product Price Is Shown On Product Page
    [Documentation]    Verify if an updated product price is displayed on the customer product page.

    Delete All Cookies
    Go To    ${BASE_URL}/admin/

    Wait Until Page Contains Element    id=id_username    5s
    Wait Until Page Contains Element    id=id_password    5s

    Input Text        id=id_username    ${ADMIN_EMAIL}
    Input Password    id=id_password    ${ADMIN_PASSWORD}
    Click Button      Log in

    Wait Until Page Contains    Site administration    5s

    Go To    ${BASE_URL}/admin/products/product/add/
    Wait Until Page Contains Element    id=id_title    5s

    Input Text        id=id_title          Robot Detail Price Test
    Input Text        id=id_description    Product used to test price display
    Input Text        id=id_price          25.00
    Select Checkbox   id=id_active
    Click Button      Save

    Wait Until Page Contains    Robot Detail Price Test    5s

    Go To    ${BASE_URL}/admin/products/product/
    Click Link    Robot Detail Price Test

    Wait Until Page Contains Element    id=id_price    5s
    Clear Element Text    id=id_price
    Input Text        id=id_price    40.00
    Click Button    Save

    Wait Until Page Contains Element    css:ul.messagelist li.success    5s

    Delete All Cookies

    Go To    ${BASE_URL}/search/
    Input Text    name=q    Robot Detail Price Test
    Click Button    Search

    Wait Until Page Contains    Robot Detail Price Test    5s
    Click Link    View

    Wait Until Page Contains    Robot Detail Price Test    5s

    Page Should Contain    40.00

TC_ADMIN_16 - Inactive Product Remains In Existing Cart
    [Documentation]    Verify an inactive product is removed from an existing customer cart.

    Delete All Cookies
    Go To    ${BASE_URL}/admin/

    Wait Until Page Contains Element    id=id_username    5s
    Wait Until Page Contains Element    id=id_password    5s

    Input Text        id=id_username    ${ADMIN_EMAIL}
    Input Password    id=id_password    ${ADMIN_PASSWORD}
    Click Button      Log in

    Wait Until Page Contains    Site administration    5s

    Go To    ${BASE_URL}/admin/products/product/add/
    Wait Until Page Contains Element    id=id_title    5s

    Input Text        id=id_title          Robot Inactive Cart Test
    Input Text        id=id_description    Product used to test inactive cart behaviour
    Input Text        id=id_price          30.00
    Select Checkbox   id=id_active
    Click Button      Save

    Wait Until Page Contains    Robot Inactive Cart Test    5s

    Delete All Cookies

    Login Test Customer
    Wait Until Page Contains    Logout    5s

    Go To    ${BASE_URL}/search/
    Input Text    name=q    Robot Inactive Cart Test
    Click Button    Search

    Wait Until Page Contains    Robot Inactive Cart Test    5s
    Click Link    View

    Wait Until Page Contains    Robot Inactive Cart Test    5s
    Click Button    Add to Cart

    Go To    ${BASE_URL}/cart/
    Page Should Contain    Robot Inactive Cart Test

    Go To    ${BASE_URL}/admin/

    Wait Until Page Contains Element    id=id_username    5s
    Wait Until Page Contains Element    id=id_password    5s

    Input Text        id=id_username    ${ADMIN_EMAIL}
    Input Password    id=id_password    ${ADMIN_PASSWORD}
    Click Button      Log in

    Wait Until Page Contains    Site administration    5s

    Go To    ${BASE_URL}/admin/products/product/
    Wait Until Page Contains    Robot Inactive Cart Test    5s
    Click Link    Robot Inactive Cart Test

    Wait Until Page Contains Element    id=id_active    5s
    Click Element    id=id_active
    Click Button    Save

    Go To    ${BASE_URL}/cart/

    Page Should Not Contain    Robot Inactive Cart Test
    Page Should Contain    Cart is empty

TC_ADMIN_17 - Admin Login Form Has Username Field
    [Documentation]    Verify Admin Login Form Has Username Field.
    Delete All Cookies
    Go To    ${BASE_URL}/admin/login/
    Page Should Contain Element    id=id_username

TC_ADMIN_18 - Admin Login Form Masks Password
    [Documentation]    Verify Admin Login Form Masks Password.
    Delete All Cookies
    Go To    ${BASE_URL}/admin/login/
    Element Attribute Value Should Be    id=id_password    type    password