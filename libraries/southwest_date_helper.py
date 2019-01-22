from datetime import datetime
from dateutil import parser

def format_my_date(mydate): 
    """
    Simple function to take a date in the format %m/%d/%Y and convert it to a format that is used on Southwest's calendar picker. 
    For example, given date 05/23/2019 return may-23
    This is required to make sure that we pick the correct date on the date picker for departure and return date.  
    """
    date = mydate
    date = date.split('/')
    day = date[1] 
    monthDict = {1:'january', 2:'february', 3:'march', 4:'april', 5:'may', 6:'june', 7:'july', 
                 8:'august', 9:'september', 10:'october', 11:'november', 12:'december'}
    month = monthDict[int(date[0])]
    return "%s-%s" % (month,day)  
    
def date_diff_months_to_shift(d1_date,d2_date):
    """
        Simple function to take 2 dates (depart and return) in the format %m/%d/%Y and calculate
        the number of shift forward on the calendar picker.
        For example, given departure 05/23/2019 return 06/10/2019 this function will return 0
        We return the difference -1 because Southwest's calendar picker shows 2 months at a time.  
    """ 
    d1 = datetime.strptime(d1_date, '%m/%d/%Y')
    d2 = datetime.strptime(d2_date, '%m/%d/%Y')
    return (d2.year - d1.year) * 12 + d2.month - d1.month-1 

def date_with_day_of_week_appended(mydate):
    """
        Simple function to take a date in the format %m/%d/%Y and return a shortened version with the 
        last 2 digits of the year along with the day of the week.
        For example, given departure 05/23/2019 return 5/23/19 Thursday
        This is used to validate any date printed on Southwest's page in the format like 5/23/19 Thursday.
    """ 
    import datetime
    month, day, year = (int(x) for x in mydate.split('/')) 
    shortened_year = abs(year) % 100 
    day_of_week = datetime.date(year, month, day).strftime("%A")
    return "%s/%s/%s %s" % (month,day,shortened_year, day_of_week)
   
