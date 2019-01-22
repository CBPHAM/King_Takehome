*** Settings ***
Documentation    
...         Set of keywords to support functionalities related to booking a flight on Southwest.
...         These keywords support the 3 pages necessary to book a flight:
...              - Southwest flight homepage  
...              - Southwest flight search results page
...              - Southwest trip and price details page
...         Majority of the ui elements has been mapped (page objects) to the corresponding pages under the folder "resources_ui". 
...         However, some of the keyword specific xpaths has been specified specifically 
...         in the keywords because we find them using local variables passed to the xpath.  
...         These are use specifially in the keyword only. 
Library     SeleniumLibrary
Library     Collections 
Library     String
Library     DateTime
Library     southwest_date_helper.py 
Resource    global_config.robot
Resource    southwest_home.robot
Resource    southwest_flight_search_results.robot
Resource    southwest_trip_price_details.robot

*** Keywords ***
Open Browser And Set Selenium Speed 
    [Arguments]    ${URL}    ${BROWSER}=${BROWSER}
    Open Browser              ${URL}    ${BROWSER}
    Set Selenium Speed        ${SEL_SPEED}

Go To Southwest Homepage And Verify
    [Arguments]    ${URL}
    Open Browser And Set Selenium Speed    ${URL}
    Wait Until Page Contains Element  ${TAB_FLIGHT}
    Wait Until Page Contains Element  ${TAB_HOTEL}

Select Adult Passenger Count
    [Arguments]      ${adult_tickets_needed}
    Click Element    ${TEXTBOX_ADULT_COUNT}
    ${passenger_count_forward}   Evaluate    ${adult_tickets_needed}-1
    :FOR   ${i}   IN RANGE   ${passenger_count_forward}
    \    Click Element    ${TEXTBOX_ADULT_COUNT_MORE}
    ${adult_count}   Get Value    ${TEXTBOX_ADULT_COUNT}
    Log    AdultCount:${adult_count}
    Should Be Equal As Numbers    ${adult_tickets_needed}    ${adult_count}   

Choose Depart And Return Dates 
    [Arguments]     ${DEPART_DATE}    ${RETURN_DATE} 
    Calculate Datepicker Counts And Get Formatted Values    ${DEPART_DATE}    ${RETURN_DATE} 
    Select Depart Date
    Select Return Date
        
Select Depart Date
    Click Element     ${TEXTBOX_DEPART_DATE}   
    :FOR   ${i}   IN RANGE    ${months_forward_depart}
    \    Click Element     ${BUTTON_DATEPICKER_NEXT}
    Click Element     id=calendar-${format_date_depart}   

Select Return Date
    Click Element     ${TEXTBOX_RETURN_DATE}  
    :FOR   ${i}   IN RANGE    ${months_forward_return}
    \    Click Element     ${BUTTON_DATEPICKER_NEXT}
    Click Element     id=calendar-${format_date_return} 

Retrieve Depart And Return Date From Results Page
    Page Should Contain Element   ${SECTION_DEPART}
    Page Should Contain Element   ${SECTION_RETURN}
    @{list_select}     Get WebElements    ${LABEL_FLIGHT_DEPART_RETURN_DATES_SELECTED}
    Length Should Be   ${list_select}    2
    ${depart_selected_element}   Set Variable   @{list_select}[0]
    Set Suite Variable    ${depart_date_selected}    ${depart_selected_element.text}
    ${return_selected_element}   Set Variable   @{list_select}[1]
    Set Suite Variable    ${return_date_selected}    ${return_selected_element.text}
    
Retrieve Depart And Return Nonstop Button Status
    @{list_radio_status}     Get WebElements    class=checkbox--content
    Length Should Be   ${list_radio_status}    2
    Log List   ${list_radio_status}
    Set Suite Variable   ${depart_nonstop_radio}    @{list_radio_status}[0]
    Set Suite Variable   ${return_nonstop_radio}    @{list_radio_status}[1]

Retrieve Available Flight By Index Order 
    [Arguments]    ${flight_flag}=depart     ${flight_index}=1
    Run Keyword If    '${flight_flag}' == 'depart'    Set Suite Variable   ${flag}   0
    Run Keyword If    '${flight_flag}' == 'return'    Set Suite Variable   ${flag}   1
    @{elements}=    Get WebElements    xpath=//*[@id="air-booking-fares-${flag}-${flight_index}"]/div
    Length Should Be   ${elements}    3
    Set Suite Variable   ${business_select_element}   @{elements}[0]
    Set Suite Variable   ${business_select_price}     ${business_select_element.text}
    Set Suite Variable   ${anytime_element}     @{elements}[1]
    Set Suite Variable   ${anytime_price}    ${anytime_element.text}
    Set Suite Variable   ${wanna_get_away_element}    @{elements}[2]
    Set Suite Variable   ${wanna_get_away_price}    ${wanna_get_away_element.text}
    
Validate Total On Trip And Price Details Page 
    [Arguments]    ${calculated_total}
    Wait Until Page Contains Element    ${CONFIRMATION_TOTAL_AMOUNT_DUE}   timeout=5s
    ${cart_total_element}    Get Web Element   ${CONFIRMATION_TOTAL_AMOUNT_DUE}
    ${cart_subtotal}   Fetch From Right    ${cart_total_element.text}    $
    Log   Cart Total:${cart_subtotal}
    Should Be True    ${cart_subtotal}<=${calculated_total}

Validate Departure And Arrival Dates On Trip And Price Details Page 
    [Arguments]    ${depart_date}   ${return_date}  
    ${depart_formatted_day_of_week}    date_with_day_of_week_appended   ${depart_date}
    ${return_formatted_day_of_week}    date_with_day_of_week_appended   ${return_date}
    @{elements}=    Get WebElements    ${CONFIRMATION_FLIGHT_DETAILS_DATES} 
    Length Should Be   ${elements}    2
    Set Suite Variable   ${depart_date_element}   @{elements}[0]
    Set Suite Variable   ${page_depart_date}     ${depart_date_element.text}
    Should Be Equal   ${depart_formatted_day_of_week}    ${page_depart_date}
    Set Suite Variable   ${return_date_element}   @{elements}[1]
    Set Suite Variable   ${page_return_date}     ${return_date_element.text}
    Should Be Equal   ${return_formatted_day_of_week}    ${page_return_date}
    
Validate Departure And Arrival Airports On Trip And Price Details Page 
    [Arguments]    ${departure_airport_code}    ${arrival_airport_code}
    ${header_booking_text}   Get Web Element    ${CONFIRMATION_DEPART_ARRIVAL_AIRPORT_CODES}
    ${page_departure_airport}   Fetch From Left     ${header_booking_text.text}    ${SPACE}
    ${page_arrival_airport}     Fetch From Right    ${header_booking_text.text}    ${SPACE}
    Should Be Equal     ${page_departure_airport.strip()}    ${departure_airport_code}
    Should Be Equal     ${page_arrival_airport.strip()}      ${arrival_airport_code}

Calculate Datepicker Counts And Get Formatted Values
    [Arguments]    ${DEPART_DATE}    ${RETURN_DATE} 
    ${current_date_formatted}    Get Current Date    result_format=%m/%d/%Y
    ${months_forward_depart}    Date Diff Months To Shift      ${current_date_formatted}   ${DEPART_DATE}
    Set Suite Variable    ${months_forward_depart}
    Log   Months:[${months_forward_depart}]
    ${months_forward_return}    Date Diff Months To Shift      ${DEPART_DATE}   ${RETURN_DATE}   
    Set Suite Variable    ${months_forward_return}  
    Log   Months:[${months_forward_return}]      
    ${format_date_depart}   format_my_date    ${DEPART_DATE}
    Set Suite Variable    ${format_date_depart}
    ${format_date_return}   format_my_date    ${RETURN_DATE}
    Set Suite Variable    ${format_date_return}  