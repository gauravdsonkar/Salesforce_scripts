#This file will have all the test cases which will make required calls to Resource.robot file

*** Settings ***
Resource                        ../Resources/common.robot
Suite Setup                     Setup Browser
Suite Teardown                  End suite


*** Test Cases ***
Create Lead via Sales Application
    [Documentation]             Create a Lead using Sales App
    [Tags]                      Lead_creation
    Open Sales Application      Sales
    ClickText                   Leads                       partial_match=false
    ClickText                   New                         partial_match=false
    UseModal                    On                                            #to start interacting with new opened window
    VerifyText                  Lead Information
    VerifyText                  Lead Owner
    ${lead_owner_name}          GetFieldValue               Lead Owner
    Should Be Equal As Strings                              ${lead_owner_name}          Gaurav Sonkar        #validating owner name as logged in user
    #ClickText                   Save                        partial_match=false
    #VerifyText                  We hit a snag.
    #VerifyText                  Name                        anchor=We hit a snag.
    #VerifyText                  Company                     anchor=We hit a snag.
    Picklist                    Salutation                  Mr.
    ${curr_time}                Get Time
    TypeText                    First Name                  Gaurav
    TypeText                    Last Name                   Sonkar_${curr_time}                        #add current time to make it unique
    Picklist                    Lead Status                 Open - Not Contacted
    ${rand_phone}=              Generate Random String      10                          [NUMBERS]
    ${phone}=                   SetVariable                 +91${rand_phone}                #generating a random string of numbers of size 10 and setting it as phone
    TypeText                    Phone                       ${phone}                    anchor=First Name
    TypeText                    Company                     Company at ${curr_time}                    Last Name
    TypeText                    Title                       Manager                     Address Information
    ${rand_email}               Generate Random String      5                        chars=GauravSonkar
    TypeText                    Email                       ${rand_email}@gmail.com        Rating
    TypeText                    Website                     https://www.growmore.com/
    Picklist                    Lead Source                 Web
    ClickText                   Save                        partial_match=False
    UseModal                    Off
    ${title_of_page}=           Get Title  
    Should Match Regexp         ${title_of_page}            ^Gaurav Sonkar                             #title of page should start with \"Gaurav Sonkar"
    Clicktext                   Details
    ${phone_onrecord}           GetFieldValue               Phone
    Should Match                ${phone_onrecord}           +91${rand_phone}                           #comparing phone number entered on form with phone number on details page


