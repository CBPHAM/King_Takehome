*** Settings ***
Documentation    This is a suite of tests to verify the scenarios given in the takehome assignment. 
...              Mainly testing the positive scenario of booking a roundtrip flight and validating at each step.
...              We are testing features in the following pages:
...                 - Southwest flight homepage  
...                 - Southwest flight search results page
...                 - Southwest trip and price details page
Resource         southwest_flight_booking.robot 
Force Tags       Southwest    Book_Flight 
Suite Teardown   Close All Browsers  
   
*** Variables ***
${URL}               http://www.southwest.com
${PASSENGER_COUNT}   2
${DEPART_DATE}       05/23/2019
${DEPART_CITY}       Oakland
${ARRIVAL_CITY}      Las Vegas
${RETURN_DATE}       06/10/2019    

*** Test Cases ***
Start Browser And Go To Southwest 
    Go To Southwest Homepage And Verify   ${URL}    

Select Passengers Required Tickets Needed 
    Select Adult Passenger Count    ${PASSENGER_COUNT}
    
Pick Depart And Return Dates 
    Choose Depart And Return Dates   ${DEPART_DATE}    ${RETURN_DATE}
    
Select Departure Airport From Search For San Francisco - OAK
    [Documentation]   Here we are highlighting the feature of searching for a city
    ...               and selecting an airport from the search list returned.
    ...               We are searching for "San Francisco" and picking Oakland (DEPART_CITY) airport from the list. 
    Input Text    ${TEXTBOX_DEPARTURE}    San Francisco
    Capture Page Screenshot
    Click Element   ${TEXTBOX_DEPARTURE}
    Click Element   xpath=id('${ID_AIRPORT_DEPARTURE}')/li[contains(text(),'${DEPART_CITY}')]
    Capture Page Screenshot
    
Select Arrival Airport From Search For Las - LAS
    [Documentation]   Here we are highlighting the feature of searching for a city
    ...               and selecting an airport from the search list returned.
    ...               We are searching for "Las" and picking Las Vegas (ARRIVAL_CITY) airport from the list.
    Input Text    ${TEXTBOX_ARRIVAL}    Las
    Capture Page Screenshot
    Click Element   ${TEXTBOX_ARRIVAL}
    Click Element   xpath=id('${ID_AIRPORT_ARRIVAL}')/li[contains(text(),'${ARRIVAL_CITY}')]
    Capture Page Screenshot    

Validate Results Page Contains Search Criterias Selected
    [Documentation]   Here we are doing the validation for the results page.
    ...               We are making sure the first and return flight information is correct.  
    ...               Because Southwest has so many different date formats that they use on various pages, 
    ...               I did not parameterize this validation.  
    ...               Though I would in a real scenario if I was writing more tests like this.
    ...               See "Validate Departure And Arrival Dates On Trip And Price Details Page" where something was done 
    ...                   to validate another date format that Southwest uses.   
    Click Button   ${BUTTON_FLIGHT_SEARCH}
    Capture Page Screenshot
    Element Should Contain    ${SECTION_DEPART}    Oakland, CA - OAK to Las Vegas, NV - LAS 
    Retrieve Depart And Return Date From Results Page
    Should Be Equal   ${depart_date_selected}   THU\nMay 23
    Element Should Contain    ${SECTION_RETURN}    Las Vegas, NV - LAS to Oakland, CA - OAK
    Should Be Equal   ${return_date_selected}   MON\nJun 10
    
Filter Non-Stop Flights And Verify 
    Retrieve Depart And Return Nonstop Button Status
    Checkbox Should Not Be Selected    ${depart_nonstop_radio}
    Checkbox Should Not Be Selected    ${return_nonstop_radio}
    Select Checkbox    ${depart_nonstop_radio}
    Element Text Should Be     ${LABEL_FLIGHT_STATUS_NONSTOP}    Nonstop
    
Select The First Nonstop Departure Flight
    [Documentation]   Here we are selecting the first nonstop flight as it was not specified.
    ...               If we had to select the cheapest flight, we have the elements and 
    ...                  we can iterate through them to find the min price.
    Retrieve Available Flight By Index Order   flight_flag=depart   flight_index=1
    Log    Business Select Price:${business_select_price}
    Log    Anytime Price:${anytime_price}
    Log    Wanna Get Away Price:${wanna_get_away_price}
    ${depart_wanna_get_away_price}   Fetch From Right    ${wanna_get_away_price}    $
    Set Suite Variable   ${depart_wanna_get_away_price} 
    Click Element    ${wanna_get_away_element}
    Capture Page Screenshot 

Select The First Nonstop Return Flight - Wanna Get Away
    [Documentation]   Here we are selecting the first nonstop flight as it was not specified.
    ...               If we had to select the cheapest flight, we have the elements and 
    ...                  we can iterate through them to find the min price.
    Retrieve Available Flight By Index Order   flight_flag=return   flight_index=1
    Log    Business Select Price:${business_select_price}
    Log    Anytime Price:${anytime_price}
    Log    Wanna Get Away Price:${wanna_get_away_price}
    ${return_wanna_get_away_price}   Fetch From Right    ${wanna_get_away_price}    $
    Set Suite Variable   ${return_wanna_get_away_price}
    Click Element    ${wanna_get_away_element} 
    Capture Page Screenshot 
    
Continue To Trip Price Details Page And Validate
    Click Element    ${BUTTON_CONTINUE_BOOKING}       
    ${calculated_total}     Evaluate   (${PASSENGER_COUNT}*${depart_wanna_get_away_price})+(${PASSENGER_COUNT}*${return_wanna_get_away_price})
    Validate Total On Trip And Price Details Page    calculated_total=${calculated_total}
    Validate Departure And Arrival Dates On Trip And Price Details Page      depart_date=${DEPART_DATE}    return_date=${RETURN_DATE}
    Validate Departure And Arrival Airports On Trip And Price Details Page   departure_airport_code=OAK      arrival_airport_code=LAS
    Capture Page Screenshot