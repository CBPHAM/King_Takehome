Overview
===============
This is a take home assignment from King Entertainment.
See SQE_TakeHome_Web.pdf for more information on the specifications. 

Installation 
===============
Robot framework with Selenium Library 
Reference: https://robotframework.org
Robot Framework Quick Start Guide: https://github.com/robotframework/QuickStartGuide/blob/master/QuickStart.rst#viewing-results
Robot Framework Libraries: https://robotframework.org/#libraries 

Versions used: 
    robotframework    3.1.1
    robotframework-seleniumlibrary    3.3.1

Robot Framework libraries used for this test:
- BuiltIn - http://robotframework.org/robotframework/latest/libraries/BuiltIn.html
- SeleniumLibrary - http://robotframework.org/SeleniumLibrary/SeleniumLibrary.html
- Collections - http://robotframework.org/robotframework/latest/libraries/Collections.html
- String - https://robotframework.org/robotframework/latest/libraries/String.html
- DateTime - https://robotframework.org/robotframework/latest/libraries/DateTime.html

Some quick installation instructions for Mac.  See Robot Framework installation instructions for more information.
- Install pip 
	sudo easy_install pip
- Install RF
	sudo pip install --user robotframework
- Install SeleniumLibrary 
	sudo pip install --user --upgrade robotframework-seleniumlibrary
- Add path (sample below are specific to my installation)
	export PATH=$PATH:/Users/cbpham_macair/Library/Python/2.7/bin
- Install browser drivers and add to path
	brew install chromedriver
	brew install geckodriver
	Add driver to path

IDE & Plug-ins
===============
Some people prefer to use PyCharm but I like to use Eclipse since I also work on other java projects.
For more information on PyCharm - https://www.jetbrains.com/pycharm/

Below is an Eclipse plug-in for Robot Framework that can be used:
Eclipse RED Robot Framework Plugin - https://github.com/nokia/RED/blob/master/installation.md

Folder Structure
===============
* King_Takehome  
  * config - Configurations specific to test environment (browser, timeouts, etc)
  * libraries - Python code to support test libraries
  * resources - Keyword resources necessary for execution (robot framework keywords)
  * resources_ui - Page Objects - ui elements mapping by page  
  * results - Sample results for a local run
    * log.html - Step by step report of tests 
    * report.html - Overall summary of tests (use this as starting point)
    * output.xml - xml output for the test run 
  * tests - contains all test suites organized by folders 
    * flight_bookings - test suites for flight bookings 
      * book_roundtrip_flight.robot (our main test is here)

Executing Tests
===============
* Executing a single test suite:
  * King_Takehome> sudo robot -P config:libraries:resources:resources_ui tests/flight_bookings/book_roundtrip_flight.robot
* Executing a tests with browser specified:
  * King_Takehome> sudo robot -P config:libraries:resources:resources_ui --variable BROWSER:Chrome tests/flight_bookings/book_roundtrip_flight.robot
  * King_Takehome> sudo robot -P config:libraries:resources:resources_ui --variable BROWSER:Firefox tests/flight_bookings/book_roundtrip_flight.robot
    * Note: Pre-requisite for browser is that you have to have the drivers installed correctly.    

Test Report
===============
We can specific where reports go on the command line for Robot Framework.  See documentation for example. 
For the purpose of simplifying this takehome, test reports gets generated in the root of the folder where you are running the test.
I have included a folder "results" where I have placed a sample of the result that I have run locally.  
Once you clone the repo, you can view report.html or log.html on any browser. 
				
