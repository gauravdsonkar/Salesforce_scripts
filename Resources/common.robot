#This file will have custom keywords and other resources which will be called from Salesforce_test.robot file

*** Settings ***
Documentation                   All libraries and custom keywords which are required throughout the script
Library                         QForce
Library                         QWeb
Library                         String
Library                         DateTime

*** Variables ***
${BROWSER}                      chrome
${login_url}                    https://login.salesforce.com
${home_url}                     ${login_url}/lightning/page/home





*** Keywords *** 

Setup Browser
    # Setting search order is used when libraries have same named keywords
    Set Library Search Order    QForce                      QWeb
    OpenBrowser                 about:blank                 ${BROWSER}
    SetConfig                   LineBreak                   ${EMPTY}                    #\ue000
    Evaluate                    random.seed()               random                      # initialize random generator
    SetConfig                   DefaultTimeout              45s                         #sometimes salesforce is slow
    # adds a delay of 0.3 between keywords. This is helpful in cloud with limited resources.
    SetConfig                   Delay                       0.3

End suite
    Close All Browsers



Fill MFA
    [Documentation]             Gets the MFA OTP code and fills the verification dialog (if needed)
    [Arguments]                 ${sf_username}=${username}                              ${mfa_secret}=${secret}     ${sf_instance_url}=${login_url}
    ${mfa_code}=                GetOTP                      ${sf_username}              ${mfa_secret}               ${login_url}
    TypeSecret                  Verification Code           ${mfa_code}
    SetConfig                   Delay                       2.3
    ClickText                   Verify


Open Sales Application
    [Documentation]             This is a script which is used for Opening Salesforce Application
    [Arguments]                 ${App_Name}
    GoTo                        ${login_url}
    TypeText                    Username                    ${username}                 delay=1s
    TypeText                    Password                    ${password}                 delay=1s
    ClickText                   Log In
    ${MFA_needed}=              Run Keyword And Return Status                           Should Not Be Equal         ${None}         ${secret}
    Run Keyword If              ${MFA_needed}               Fill MFA                    ${username}              ${secret}       ${login_url}
    #VerifyTitle                 Home | Salesforce           20s
    #ClickElement               /html/body/div[4]/div[1]/section/div[2]/div[1]/one-appnav/div/div/div/div/one-app-launcher-header/button                  10s
    #TypeText                   Search apps and items...    Sales
    #Click Element              xpath=//b[text()='Sales']                               partial_match=false
    #SetConfig                  SearchDirection             down
    VerifyText                  ${App_Name}                 10s
    


