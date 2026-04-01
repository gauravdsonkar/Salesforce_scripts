#This file will have custom keywords and other resources which will be called from Salesforce_test.robot file

*** Settings ***
Documentation       All libraries which are required throughout the script
Library             QForce
Library             QWeb
Library             String

*** Variables ***
${BROWSER}          chrome
${sfdc_url}         https://login.salesforce.com
${sfdc_home_url}    ${sfdc_url}/lightning/page/home




*** Keywords *** 
Open Browser for testing
    Set Library Search Order                          QForce    QWeb
    [Documentation]    this test case opens browser for testing
    Open Browser    about:blank    ${BROWSER}
    SetConfig       DefaultTimeout       30s 
    

Close browser
    Close All Browsers  
    
Login     
    [Documentation]       Login to Salesforce instance by providing username and password
    [Arguments]           ${sf_instance_url}=${sfdc_home_url}    ${sf_username}=${username}   ${sf_password}=${password}  
    GoTo                  ${sf_instance_url}
    TypeText              Username                    ${sf_username}             delay=1
    TypeSecret            Password                    ${sf_password}
    ClickText             Log In
    # We'll check if variable ${secret} is given. If yes, fill the MFA dialog.
    # If not, MFA is not expected.
    # ${secret} is ${None} unless specifically given.
    ${MFA_needed}=       Run Keyword And Return Status          Should Not Be Equal    ${None}       ${secret}
    Run Keyword If       ${MFA_needed}               Fill MFA   ${sf_username}         ${secret}    ${sf_instance_url}
    

Fill MFA
    [Documentation]      Gets the MFA OTP code and fills the verification dialog (if needed)
    [Arguments]          ${sf_username}=${username}    ${mfa_secret}=${secret}  ${sf_instance_url}=${sfdc_url}
    ${mfa_code}=         GetOTP    ${sf_username}   ${mfa_secret}   ${sfdc_url}  
    TypeSecret           Verification Code       ${mfa_code}      
    ClickText            Verify 


Home
    [Documentation]       Example appstarte: Navigate to homepage, login if needed
    GoTo                  ${sfdc_home_url}
    ${login_status} =     IsText                      To access this page, you have to log in to Salesforce.    2
    Run Keyword If        ${login_status}             Login
    ClickText             Home
    VerifyTitle           Home | Salesforce

