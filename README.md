# DateTimeStepWith

Filter Ruby Date or DateTime collections using cron pattern.

## Installation

    $ gem install date_time_step_with

## Usage


####Date class

    require 'date'
    require 'date_time_step_with'
 
    Date.include DateTimeStepWith::CronMatcher
    Date.include DateTimeStepWith::CronStepper

    date_from = Date.new(2015,1,1)
    date_to   = Date.new(2015,12,31)
    date_from.step_with_cron("* * 12,15 7,8,12 * 2015", date_to).collect {|date| date.strftime("%Y-%m-%d")}
    => ["2015-07-12", "2015-07-15", "2015-08-12", "2015-08-15", "2015-12-12", "2015-12-15"]
    
    
    

####DateTime class

    require 'time'    
    require 'date_time_step_with'

    DateTime.include DateTimeStepWith::CronMatcher
    DateTime.include DateTimeStepWith::CronStepper
    
    one_minute_step = (1.to_f/24/60)
      
    date_from = DateTime.new(2015,1,1,0,0)
    date_to   = DateTime.new(2015,12,31,0,0)
    date_from.step_with_cron("10-15 5,6,7 15 11 * 2015", date_to, one_minute_step).collect{|date| date.strftime("%Y-%m-%d %H:%M")}    
    => ["2015-11-15 05:10", "2015-11-15 05:11", "2015-11-15 05:12", "2015-11-15 05:13", "2015-11-15 05:14", "2015-11-15 05:15", 
        "2015-11-15 06:10", "2015-11-15 06:11", "2015-11-15 06:12", "2015-11-15 06:13", "2015-11-15 06:14", "2015-11-15 06:15", 
        "2015-11-15 07:10", "2015-11-15 07:11", "2015-11-15 07:12", "2015-11-15 07:13", "2015-11-15 07:14", "2015-11-15 07:15"]
   
   
## TODO

* Improve performace. Iteration on wide ranges steping in minutes take long.
* Add ICAL RRULE expression stepper
