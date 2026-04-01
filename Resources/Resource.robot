#This file will have custom keywords and other resources which will be called from Salesforce_test.robot file

*** Settings ***
Documentation                   All libraries which are required throughout the script
Library                         QForce
Library                         QWeb
Library                         String
Library                         DateTime

*** Variables ***
${BROWSER}                      chrome
${sfdc_url}                     https://login.salesforce.com
${sfdc_home_url}                ${sfdc_url}/lightning/page/home
${secret}                       ABFGP3RIPT4KWE7CNMKVF7GOXAX6RWUT




*** Keywords *** 
Setup Browser
    # Setting search order is not really needed here, but given as an example 
    # if you need to use multiple libraries containing keywords with duplicate names
    Set Library Search Order                          QForce    QWeb
    Open Browser          about:blank                 ${BROWSER}
    SetConfig             LineBreak                   ${EMPTY}               #\ue000
    Evaluate              random.seed()               random                 # initialize random generator
    SetConfig             DefaultTimeout              45s                    #sometimes salesforce is slow
    # adds a delay of 0.3 between keywords. This is helpful in cloud with limited resources.
    SetConfig             Delay                       0.3

End suite
    Close All Browsers
Login     
    [Documentation]             Login to Salesforce instance by providing username and password
    [Arguments]                 ${sf_instance_url}=${sfdc_home_url}                     ${sf_username}=${username}                 ${sf_password}=${password}
    GoTo                        ${sf_instance_url}
    TypeText                    Username                    ${sf_username}              delay=1
    TypeSecret                  Password                    ${sf_password}
    ClickText                   Log In
    # We'll check if variable ${secret} is given. If yes, fill the MFA dialog.
    # If not, MFA is not expected.
    # ${secret} is ${None} unless specifically given.
    ${MFA_needed}=              Run Keyword And Return Status                           Should Not Be Equal         ${None}        ${secret}
    Run Keyword If              ${MFA_needed}               Fill MFA                    ${sf_username}              ${secret}      ${sf_instance_url}


Fill MFA
    [Documentation]             Gets the MFA OTP code and fills the verification dialog (if needed)
    [Arguments]                 ${sf_username}=${username}                              ${mfa_secret}=${secret}     ${sf_instance_url}=${sfdc_url}
    ${mfa_code}=                GetOTP                      ${sf_username}              ${mfa_secret}               ${sfdc_url}
    TypeSecret                  Verification Code           ${mfa_code}
    ClickText                   Verify


Home
    [Documentation]             Example appstarte: Navigate to homepage, login if needed
    GoTo                        ${sfdc_home_url}
    ${login_status} =           IsText                      To access this page, you have to log in to Salesforce.                 2
    Run Keyword If              ${login_status}             Login
    ClickText                   Home
    VerifyTitle                 Home | Salesforce

