*** Settings ***
Documentation    Automated Functional Testing for E-Commerce System
Resource         ecommerce_resources.robot
Suite Setup      Open E-Commerce Website
Suite Teardown   Close All Browsers


*** Test Cases ***


# REGISTRATION TESTS


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


# LOGIN TESTS
# All 7 required login combinations


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



# LOGOUT TEST


# LOGOUT TEST

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

    
# CONTACT FORM TESTS

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
