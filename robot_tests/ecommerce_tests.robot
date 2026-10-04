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
    Delete All Cookies
    Login Test Customer

    Go To    ${BASE_URL}/products/t-shirt-6qp8/
    Wait Until Page Contains    T-Shirt     5s

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

    Wait Until Page Contains    Billing Address    5s

    Input Text    id=id_address_line_1    1 Robot Street
    Input Text    id=id_address_line_2    Test Building
    Input Text    id=id_city              Darwin
    Input Text    id=id_country           Australia
    Input Text    id=id_state             NT
    Input Text    id=id_postal_code       0800
    Click Button    Submit

    Wait Until Page Contains    Finalize Checkout    5s
    Click Button    Finalize Checkout
    Wait Until Page Contains    Thank you    5s

TC_CHECK_02 - Checkout With Missing Required Information
    [Documentation]    Verify required checkout information is validated.
    Delete All Cookies
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

    Click Button    Submit

    Location Should Contain    /cart/checkout/
    Page Should Contain    Shipping Address

TC_CHECK_03 - Checkout With Empty Cart
    [Documentation]    Verify checkout cannot proceed with an empty cart.
    Delete All Cookies
    Login Test Customer
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

TC_CHECK_04 - Verify Order Total
    [Documentation]    Verify the correct total of the order is displayed at checkout
    Delete All Cookies
    Login Test Customer

    Go To    ${BASE_URL}/products/t-shirt-6qp8/
    Wait Until Page Contains    T-Shirt    8s

    ${add_exists}=    Run Keyword And Return Status
    ...    Page Should Contain Button    Add to Cart

    IF    ${add_exists}
        Click Button    Add to Cart
    END

    Go To    ${BASE_URL}/cart/
    Page Should Contain    T-Shirt
    Page Should Contain    43.19

    Go To    ${BASE_URL}/cart/checkout/
    Page Should Contain    Shipping Address

    Input Text    id=id_address_line_1    1 Robot Street
    Input Text    id=id_address_line_2    Test Unit
    Input Text    id=id_city              Darwin City
    Input Text    id=id_country           Australia
    Input Text    id=id_state             NT
    Input Text    id=id_postal_code       0800
    Click Button    Submit

    Wait Until Page Contains    Billing Address    5s
    Input Text    id=id_address_line_1    1 Robot Street
    Input Text    id=id_address_line_2    Test Unit
    Input Text    id=id_city              Darwin City
    Input Text    id=id_country           Australia
    Input Text    id=id_state             NT
    Input Text    id=id_postal_code       0800
    Click Button    Submit

    Wait Until Page Contains    Finalize Checkout    5s
    Page Should Contain    Cart Total
    Page Should Contain    43.19
    Page Should Contain    Shipping Total
    Page Should Contain    5.99
    Page Should Contain    Order Total
    Page Should Contain    49.18

TC_CHECK_05 - Checkout With Missing Billing Details
    [Documentation]    Verify if the needed billing detials are validated
    Delete All Cookies
    Login Test Customer

    Go To    ${BASE_URL}/products/t-shirt-6qp8/
    Wait Until Page Contains    T-Shirt    8s

    ${add_exists}=    Run Keyword And Return Status
    ...    Page Should Contain Button    Add to Cart

    IF    ${add_exists}
        Click Button    Add to Cart
    END

    Go To    ${BASE_URL}/cart/
    Wait Until Page Contains    T-Shirt    8s

    Go To    ${BASE_URL}/cart/checkout/
    Page Should Contain    Shipping Address

    Input Text    id=id_address_line_1    1 Robot Street
    Input Text    id=id_address_line_2    Test Unit
    Input Text    id=id_city              Darwin City
    Input Text    id=id_country           Australia
    Input Text    id=id_state             NT
    Input Text    id=id_postal_code       0800
    Click Button    Submit

    Wait Until Page Contains    Billing Address    5s

    Click Button    Submit

    Location Should Contain    /cart/checkout/
    Page Should Contain    Billing Address

TC_CHECK_06 - Checked if different shipping and billing addresses are stored seperately
    [Documentation]    Verify the different shipping and billing addresses of the order is displayed
    Delete All Cookies
    Login Test Customer

    Go To    ${BASE_URL}/products/t-shirt-6qp8/
    Wait Until Page Contains    T-Shirt    8s

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
    Input Text    id=id_address_line_2    Test Unit
    Input Text    id=id_city              Darwin City
    Input Text    id=id_country           Australia
    Input Text    id=id_state             NT
    Input Text    id=id_postal_code       0800
    Click Button    Submit

    Wait Until Page Contains    Billing Address    5s
    Input Text    id=id_address_line_1    2 Billing Street
    Input Text    id=id_address_line_2    Test2 Unit
    Input Text    id=id_city              Darwin City
    Input Text    id=id_country           Australia
    Input Text    id=id_state             NT
    Input Text    id=id_postal_code       0800
    Click Button    Submit

    Wait Until Page Contains    Finalize Checkout    5s
    Page Should Contain    1 Robot Street
    Page Should Contain    2 Billing Street

TC_CHECK_07 - Checking if the cart is empty after checkout
    [Documentation]    Verify the cart is empty after checkout.
    Delete All Cookies
    Login Test Customer

    Go To    ${BASE_URL}/products/t-shirt-6qp8/
    Wait Until Page Contains    T-Shirt     5s

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

    Wait Until Page Contains    Billing Address    5s

    Input Text    id=id_address_line_1    1 Robot Street
    Input Text    id=id_address_line_2    Test Building
    Input Text    id=id_city              Darwin
    Input Text    id=id_country           Australia
    Input Text    id=id_state             NT
    Input Text    id=id_postal_code       0800
    Click Button    Submit

    Wait Until Page Contains    Finalize Checkout    5s
    Click Button    Finalize Checkout
    Wait Until Page Contains    Thank you    5s

    Go To    ${BASE_URL}/cart/
    Wait Until Page Contains    Cart is empty    5s
    Page Should Contain    Cart is empty

TC_CHECK_08 - Checking if saved addressed can be reused
    [Documentation]    Verify if previous addresses can be resued at checkout.
    Delete All Cookies
    Login Test Customer

    Go To    ${BASE_URL}/products/t-shirt-6qp8/
    Wait Until Page Contains    T-Shirt     5s

    ${add_exists}=    Run Keyword And Return Status
    ...    Page Should Contain Button    Add to Cart

    IF    ${add_exists}
        Click Button    Add to Cart
    END

    Go To    ${BASE_URL}/cart/
    Page Should Contain    T-Shirt

    Go To    ${BASE_URL}/cart/checkout/
    Page Should Contain    Shipping Address

    Input Text    id=id_address_line_1    199 Robot Street
    Input Text    id=id_address_line_2    Saved Address Unit
    Input Text    id=id_city              Darwin
    Input Text    id=id_country           Australia
    Input Text    id=id_state             NT
    Input Text    id=id_postal_code       0800
    Click Button    Submit

    Wait Until Page Contains     Billing Address    5s
    Page Should Contain    199 Robot Street

TC_CHECK_09 - Checking login from checkout 
    [Documentation]    Verify a customer can login from checkout and continue the checkout proccess
    Delete All Cookies

    Go To    ${BASE_URL}/products/t-shirt-6qp8/
    Wait Until Page Contains    T-Shirt     5s

    ${add_exists}=    Run Keyword And Return Status
    ...    Page Should Contain Button    Add to Cart

    IF    ${add_exists}
        Click Button    Add to Cart
    END

    Go To    ${BASE_URL}/cart/
    Page Should Contain    T-Shirt

    Go To    ${BASE_URL}/cart/checkout/
    Wait Until Page Contains    Login    5s
    Page Should Contain Element    id=id_email
    Page Should Contain Element    id=id_password

    Input Text    id=id_email    ${TEST_EMAIL}
    Input Text    id=id_password    ${TEST_PASSWORD}
    Click Button    Login

    Wait Until Page Contains    Shipping Address    5s
    Location Should Contain    /cart/checkout/
    Page Should Contain    Shipping Address


TC_CHECK_10 - Checks If Guest Checkout Option Is Shown
    [Documentation]    Verify the guest checkout option is visible to a guest customer.

    Delete All Cookies

    Go To    ${BASE_URL}/products/t-shirt-6qp8/
    Wait Until Page Contains    T-Shirt    5s

    ${add_exists}=    Run Keyword And Return Status
    ...    Page Should Contain Button    Add to Cart

    IF    ${add_exists}
        Click Button    Add to Cart
    END

    Go To    ${BASE_URL}/cart/checkout/
    Wait Until Page Contains    Login    5s

    Page Should Contain    Guest

TC_CHECK_11 - Checking an Invalid Order Can Be Completed
    [Documentation]    Verify if an invalid order cannot be completed successfully.

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

    Input Text        id=id_title          Robot Invalid Order Test
    Input Text        id=id_description    Product used to test invalid checkout
    Input Text        id=id_price          -20.00
    Select Checkbox   id=id_active
    Click Button      Save

    Wait Until Page Contains    Robot Invalid Order Test    5s

    Delete All Cookies
    Login Test Customer
    Wait Until Page Contains    Logout    5s

    Go To    ${BASE_URL}/products/robot-invalid-order-test/
    Wait Until Page Contains    Robot Invalid Order Test    5s
    Click Button    Add to Cart

    Go To    ${BASE_URL}/cart/
    Page Should Contain    Robot Invalid Order Test
    Page Should Contain    -20.00

    Go To    ${BASE_URL}/cart/checkout/
    Page Should Contain    Shipping Address

    Input Text    id=id_address_line_1    1 Robot Street
    Input Text    id=id_address_line_2    Test Building
    Input Text    id=id_city              Darwin
    Input Text    id=id_country           Australia
    Input Text    id=id_state             NT
    Input Text    id=id_postal_code       0800
    Click Button    Submit

    Wait Until Page Contains    Billing Address    5s

    Input Text    id=id_address_line_1    1 Robot Street
    Input Text    id=id_address_line_2    Test Building
    Input Text    id=id_city              Darwin
    Input Text    id=id_country           Australia
    Input Text    id=id_state             NT
    Input Text    id=id_postal_code       0800
    Click Button    Submit

    Wait Until Page Contains    Finalize Checkout    5s

    Page Should Contain    Order Total
    Page Should Contain    -14.01

    Click Button    Finalize Checkout

    Page Should Not Contain    Thank you for your order

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

    Input Text    id=id_title          Negative Price Test
    Input Text    id=id_description    Product used to test negative price
    Input Text    id=id_price          -20.00
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
    Input Text    id=id_price    40.00
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