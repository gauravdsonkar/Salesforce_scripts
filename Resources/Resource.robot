#This file will have custom keywords and other resources which will be called from Salesforce_test.robot file

*** Settings ***
Documentation       All libraries which are required throughout the script
Library             QForce
Library             QWeb
Library             String

*** Variables ***
${BROWSER}           chrome
${sfdc_url}         https://login.salesforce.com
${sfdc_home_url}    ${sfdc_url}/lightning/page/home




*** Test Cases ***
Open Browser for testing
    Documentation    this test case opens browser for testing
    Open Browser    about:${sfdc_url}    ${BROWSER}
    SetConfig       defaultTimeout       30s