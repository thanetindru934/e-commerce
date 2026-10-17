*** Settings ***
Documentation    Automated Functional Testing for E-Commerce System
Resource         ecommerce_resources.robot
Suite Setup      Open E-Commerce Website
Suite Teardown   Close All Browsers


*** Test Cases ***


# REGISTRATION TESTS


*** Test Cases ***

# ============================================================
# REGISTRATION TESTS (13)
# ============================================================
TC_REG_01 - Register With Valid Details
    [Documentation]    Verify registration succeeds with a new valid account.

    ${unique}=    Evaluate    __import__('uuid').uuid4().hex[:12]
    ${email}=    Set Variable    robot_${unique}@example.com

    Go To Registration
    Input Text        id=id_full_name    Robot Test Customer
    Input Text        id=id_email        ${email}
    Input Password    id=id_password1    ${TEST_PASSWORD}
    Input Password    id=id_password2    ${TEST_PASSWORD}

    Click Button    Register

    Sleep    2s
    Log Location
    Log Source
    Capture Page Screenshot

    Wait Until Location Is    ${BASE_URL}/login/    10s
    Page Should Contain    Login

TC_REG_02 - Register With Existing Email
    [Documentation]    Verify registration is rejected when the email already exists.

    Go To Registration
    Input Text        id=id_full_name    Duplicate Customer
    Input Text        id=id_email        ${TEST_EMAIL}
    Input Password    id=id_password1    ${TEST_PASSWORD}
    Input Password    id=id_password2    ${TEST_PASSWORD}

    Click Button    Register

    Wait Until Location Is    ${BASE_URL}/register/    10s
    Capture Page Screenshot
    Log Source

    Page Should Contain    Register

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
