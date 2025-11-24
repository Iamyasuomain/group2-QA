*** Settings ***
Documentation    End-to-end test for product creation and purchase flow using a single file.
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

# --- Common Selectors (Update these for your application) ---
${USERNAME_FIELD}     name:email
${PASSWORD_FIELD}     name:password
${USER_LOGIN_BUTTON}       xpath://button[text()='Sign in']
${ADMIN_LOGIN_BUTTON}       xpath://button[text()='Continue with Email']
${DASHBOARD_CHECK}    xpath://div[@data-testid='dashboard-content']

*** Keywords ***
Open Browsers And Set Aliases
    # Opens two separate browser instances for concurrent testing
    Open Browser    ${CUSTOMER_LOGIN_URL}    Chrome    alias=Customer_Browser
    Maximize Browser Window
    Open Browser    ${ADMIN_LOGIN_URL}       Chrome    alias=Admin_Browser
    Maximize Browser Window
    
Login To Site
    [Arguments]    ${alias}    ${username}    ${password}
    Switch Browser    ${alias}
    Input Text    ${USERNAME_FIELD}    ${username}
    Input Password    ${PASSWORD_FIELD}    ${password}
    Click Button    ${ADMIN_LOGIN_BUTTON}
    Wait Until Page Contains Element    ${DASHBOARD_CHECK}    timeout=10s
    Log To Console    Successfully logged into ${alias}.

Admin Log In
    Login To Site    Admin_Browser    ${ADMIN_USER}    ${ADMIN_PASS}

Admin Create And Publish Product
    Switch Browser    Admin_Browser
    # S.No 2. & 3.: Navigate, Fill details, and Publish product
    Click Link    xpath://a[text()='Products']
    Click Button    xpath://button[text()='Create Product']
    Input Text    id:product-name    Test E2E Product
    # 
    Click Button    xpath://button[text()='Publish']
    Log To Console    Product created and published.

Customer Log In
    Login To Site    Customer_Browser    ${CUSTOMER_USER}    ${CUSTOMER_PASS}

Customer Browse Add To Cart
    Switch Browser    Customer_Browser
    # S.No 5. & 6.: Browse product, add to cart
    Input Text    id:search-box    Test E2E Product
    Click Link    xpath://h3[text()='Test E2E Product']
    Click Button    id:add-to-cart
    Log To Console    Product added to cart.

Customer Checkout And Place Order
    Switch Browser    Customer_Browser
    # S.No 7.: Go to checkout, place order
    Click Link    id:cart-icon
    Click Button    id:checkout-button
    # Input shipping address, select express shipping, choose manual payment
    # 

[Image of Customer Checkout Page]

    # ... Add detailed steps for form filling and order placement here ...
    Click Button    id:place-order
    Log To Console    Order placed successfully.

Admin Manage Order And Mark Delivered
    Switch Browser    Admin_Browser
    # S.No 8. & 10.: Capture Payment, Fulfill, Mark Delivered
    Click Link    xpath://a[text()='Orders']
    # Find the newly placed order based on title/ID
    Click Link    xpath://a[contains(text(), 'New Customer Order')]
    Click Button    xpath://button[text()='Capture Payment']
    Click Button    xpath://button[text()='Fulfill Items']
    Click Button    xpath://button[text()='Mark as Delivered']
    Log To Console    Order managed and marked as delivered by Admin.

Customer View Order History
    Switch Browser    Customer_Browser
    # S.No 9.: Navigate to history, view details
    Click Link    id:account-link
    Click Link    xpath://a[text()='Order History']
    Click Link    xpath://a[contains(text(), 'Order #')]
    Log To Console    Customer viewing final order details.

*** Test Cases ***
E2E Product Creation And Purchase Flow
    # 1. & 2. & 3. Admin: Log in, Create & Publish Product
    Admin Log In
    Admin Create And Publish Product

    # 4. & 5. & 6. Customer: Log in, Browse, Add to Cart
    Customer Log In
    Customer Browse Add To Cart

    # 7. Customer: Checkout and Place Order
    Customer Checkout And Place Order

    # 8. & 10. Admin: Manage the Order and Mark Delivered
    Admin Manage Order And Mark Delivered

    # 9. Customer: Go to Order History and view details
    Customer View Order History
    
    Log    Test completed successfully.