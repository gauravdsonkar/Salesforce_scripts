#This file will have all the test cases which will make required calls to Resource.robot file

*** Settings ***
Resource    ../Resources/Resource.robot
Suite Setup    Open Browser For testing
Suite Teardown    Close browser