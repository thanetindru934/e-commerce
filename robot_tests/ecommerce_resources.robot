*** Settings ***
Library    SeleniumLibrary
Library    String
Library    DateTime


*** Variables ***
${BASE_URL}          http://127.0.0.1:8000
${BROWSER}           chrome

${TEST_PASSWORD}     RobotTest@123
${ADMIN_EMAIL}       robotadmin@example.com
${ADMIN_PASSWORD}    AdminTest@123

${TEST_EMAIL}        ${EMPTY}


*** Keywords ***
Open E-Commerce Website
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout    10 seconds

    ${stamp}=    Get Current Date    result_format=%Y%m%d%H%M%S%f
    ${random}=    Generate Random String    6    [LOWER][NUMBERS]
    ${email}=    Set Variable    robot_${stamp}_${random}@example.com
    Set Suite Variable    ${TEST_EMAIL}    ${email}


Go To Registration
    Go To    ${BASE_URL}/register/


Go To Login
    Go To    ${BASE_URL}/login/


Go To Products
    Go To    ${BASE_URL}/products/


Go To Cart
    Go To    ${BASE_URL}/cart/


Register Test Customer
    Go To Registration
    Input Text        id=id_full_name    Robot Test Customer
    Input Text        id=id_email        ${TEST_EMAIL}
    Input Password    id=id_password1    ${TEST_PASSWORD}
    Input Password    id=id_password2    ${TEST_PASSWORD}
    Click Button      Register


Login Test Customer
    Go To Login
    Input Text        id=id_email       ${TEST_EMAIL}
    Input Password    id=id_password    ${TEST_PASSWORD}
    Click Button      Login


Add T-Shirt To Cart
    Go To    ${BASE_URL}/products/t-shirt-6qp8/
    ${remove}=    Run Keyword And Return Status
    ...    Page Should Contain Button    Remove?

    IF    not ${remove}
        Click Button    Add to Cart
    END


Add Hat To Cart
    Go To    ${BASE_URL}/products/hat/
    ${remove}=    Run Keyword And Return Status
    ...    Page Should Contain Button    Remove?

    IF    not ${remove}
        Click Button    Add to Cart
    END