#This file will have custom keywords and other resources which will be called from Salesforce_test.robot file

*** Settings ***
Documentation                   All libraries which are required throughout the script
Library                         QForce
Library                         QWeb
Library                         String
Library                         DateTime

*** Variables ***
${BROWSER}                      chrome
${login_url}                    https://login.salesforce.com
${home_url}                     ${login_url}/lightning/page/home
${secret}                       QVANSQW2EA4ZVOAGNLWKKFNHHM27LUT3




*** Keywords *** 

Setup Browser
    # Setting search order is not really needed here, but given as an example
    # if you need to use multiple libraries containing keywords with duplicate names
    Set Library Search Order    QForce                      QWeb
    OpenBrowser                 about:blank                 ${BROWSER}
    SetConfig                   LineBreak                   ${EMPTY}                    #\ue000
    Evaluate                    random.seed()               random                      # initialize random generator
    SetConfig                   DefaultTimeout              45s                         #sometimes salesforce is slow
    # adds a delay of 0.3 between keywords. This is helpful in cloud with limited resources.
    SetConfig                   Delay                       0.3

End suite
    Close All Browsers

Login
    [Documentation]             Login to Salesforce instance. Takes instance_url, username and password as
    ...                         arguments. Uses values given in Copado Robotic Testing's variables section by default.
    [Arguments]                 ${sf_instance_url}=${login_url}                         ${sf_username}=${username}                  ${sf_password}=${password}
    GoTo                        ${sf_instance_url}
    TypeText                    Username                    ${sf_username}              delay=1
    TypeSecret                  Password                    ${sf_password}
    ClickText                   Log In
    # We'll check if variable ${secret} is given. If yes, fill the MFA dialog.
    # If not, MFA is not expected.
    # ${secret} is ${None} unless specifically given.
    Log To Console              ${secret}
    ${MFA_needed}=              Run Keyword And Return Status                           Should Not Be Equal         ${None}         ${secret}
    Run Keyword If              ${MFA_needed}               Fill MFA                    ${sf_username}              ${secret}       ${sf_instance_url}


Login As
    [Documentation]             Login As different persona. User needs to be logged into Salesforce with Admin rights
    ...                         before calling this keyword to change persona.
    ...                         Example:
    ...                         LoginAs                     Chatter Expert
    [Arguments]                 ${persona}
    ClickText                   Setup
    ClickItem                   Setup                       delay=1
    SwitchWindow                NEW
    TypeText                    Search Setup                ${persona}                  delay=2
    ClickElement                //*[@title\="${persona}"]                               delay=2                     # wait for list to populate, then click
    VerifyText                  Freeze                      timeout=45                  # this is slow, needs longer timeout
    ClickText                   Login                       anchor=Freeze               partial_match=False         delay=1


Fill MFA
    [Documentation]             Gets the MFA OTP code and fills the verification dialog (if needed)
    [Arguments]                 ${sf_username}=${username}                              ${mfa_secret}=${secret}     ${sf_instance_url}=${login_url}
    ${mfa_code}=                GetOTP                      ${sf_username}              ${mfa_secret}               ${login_url}
    TypeSecret                  Verification Code           ${mfa_code}
    SetConfig                   Delay                       2.3
    ClickText                   Verify



Home
    [Documentation]             Example appstarte: Navigate to homepage, login if needed
    GoTo                        ${home_url}
    ${login_status} =           IsText                      To access this page, you have to log in to Salesforce.                  2
    Run Keyword If              ${login_status}             Login
    ClickText                   Home
    VerifyTitle                 Home | Salesforce

Open Required Application
    [Documentation]             This is a script which is used for Opening Salesforce Application
    [Arguments]                 ${App_Name}
    GoTo                        ${login_url}
    TypeText                    Username                    ${username}                 delay=1s
    TypeText                    Password                    ${password}                 delay=1s
    ClickText                   Log In
    ${MFA_needed}=              Run Keyword And Return Status                           Should Not Be Equal         ${None}         ${secret}
    Run Keyword If              ${MFA_needed}               Fill MFA                    ${sf_username}              ${secret}       ${sf_instance_url}
    VerifyTitle                 Home | Salesforce           20s
    #ClickElement               /html/body/div[4]/div[1]/section/div[2]/div[1]/one-appnav/div/div/div/div/one-app-launcher-header/button                  10s
    #TypeText                   Search apps and items...    Sales
    #Click Element              xpath=//b[text()='Sales']                               partial_match=false
    #SetConfig                  SearchDirection             down
    LaunchApp                   ${App_Name}
    VerifyText                  ${App_Name}
    ClickElement                //span[text()/='Sales']     10s
    #VerifyText                 Sales                       anchor=App Launcher         partial_match=false


