*** Settings ***
Documentation    Test to verify login functionality for both Admin and Customer sites.
Library          SeleniumLibrary
Test Setup       Open Browsers And Set Aliases
Test Teardown    Close All Browsers

*** Variables ***
# --- Site URLs ---
${ADMIN_LOGIN_URL}    http://10.34.112.158:9000/app/login
${CUSTOMER_LOGIN_URL}    http://10.34.112.158:8000/dk/account

# --- User Credentials ---
${ADMIN_USER}         group2@mu-store.local
${ADMIN_PASS}         Kt5#uWq9
${CUSTOMER_USER}      testz@gmail.com
${CUSTOMER_PASS}      testz@gmail.com

# --- Common Selectors (Verified for your setup) ---
${USERNAME_FIELD}     name:email
${PASSWORD_FIELD}     name:password
${CUSTOMER_LOGIN_BUTTON}       xpath://button[text()='Sign in']
${ADMIN_LOGIN_BUTTON}       xpath://button[text()='Continue with Email']
${ADMIN_DASHBOARD_CHECK}    xpath://div[@data-testid='dashboard-content']
${CUSTOMER_ACCOUNT_CHECK}   xpath://h1[contains(text(), 'My Account') or contains(text(), 'Oversigt')]
# Note: Oversigt is Danish for Overview, used for account check

*** Keywords ***
Open Browsers And Set Aliases
    # Opens two separate browser instances for concurrent testing
    Open Browser    ${CUSTOMER_LOGIN_URL}    Chrome    alias=Customer_Browser
    Maximize Browser Window
    Open Browser    ${ADMIN_LOGIN_URL}       Chrome    alias=Admin_Browser
    Maximize Browser Window
    
Execute Login
    [Arguments]    ${alias}    ${username}    ${password}    ${button_selector}    ${success_check}
    Switch Browser    ${alias}
    Log To Console    Attempting login for ${alias} with user: ${username}
    Input Text    ${USERNAME_FIELD}    ${username}
    Input Password    ${PASSWORD_FIELD}    ${password}
    Click Button    ${button_selector}
    Wait Until Page Contains Element    ${success_check}    timeout=15s
    Log To Console    Successfully logged into ${alias}.

Admin Log In
    Execute Login    Admin_Browser    ${ADMIN_USER}    ${ADMIN_PASS}    ${ADMIN_LOGIN_BUTTON}    ${ADMIN_DASHBOARD_CHECK}

Customer Log In
    Execute Login    Customer_Browser    ${CUSTOMER_USER}    ${CUSTOMER_PASS}    ${CUSTOMER_LOGIN_BUTTON}    ${CUSTOMER_ACCOUNT_CHECK}

*** Test Cases ***
Verify Dual Site Login Success
    # 1. Admin: Log in
    Admin Log In
    
    # 2. Customer: Log in
    Customer Log In
    
    Log    Both Admin and Customer logins verified successfully.