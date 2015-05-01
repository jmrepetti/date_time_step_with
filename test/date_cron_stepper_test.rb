require 'time'
require 'minitest/autorun'
require 'date_time_step_with'

Time.include DateTimeStepWith::CronMatcher
Time.include DateTimeStepWith::CronStepper
Date.include DateTimeStepWith::CronMatcher
Date.include DateTimeStepWith::CronStepper
DateTime.include DateTimeStepWith::CronMatcher
DateTime.include DateTimeStepWith::CronStepper


class CronStepperTest < Minitest::Test

  def test_mondays_collection
    date = Date.new(2015,4,1)
    date_limit = Date.new(2015,4,30)
    cron_mondays = date.step_with_cron("* * * * 1 *", date_limit) do |d| 
      assert d.monday?
    end
  end
  
  def test_days_collection
    date = Date.new(2015,4,1)
    date_limit = Date.new(2015,4,30)
    days = date.step(date_limit).collect{|e| e}
    cron_days = date.step_with_cron("00 00 * * * *", date_limit).collect{|e| e}
    assert_equal days, cron_days
  end

  def test_range_collection
    date = Date.new(2015,4,1)
    date_limit = Date.new(2015,6,30)
    
    days = []
    days << Date.new(2015,4,12).step(Date.new(2015,4,20)).collect {|e| e}
    days << Date.new(2015,5,12).step(Date.new(2015,5,20)).collect {|e| e}
    days << Date.new(2015,6,12).step(Date.new(2015,6,20)).collect {|e| e}
    
    cron_days = date.step_with_cron("00 00 12-20 * * 2015", date_limit).collect{|e| e}
    assert_equal days.flatten, cron_days
  end
  
  def test_list_collection
    date = Date.new(2015,7,1)
    date_limit = Date.new(2015,12,30)
    
    days = [
      Date.new(2015,7,12),
      Date.new(2015,7,15),
      Date.new(2015,8,12),
      Date.new(2015,8,15),
      Date.new(2015,12,12),
      Date.new(2015,12,15),
    ]
  
    cron_days = date.step_with_cron("00 00 12,15 7,8,12 * 2015", date_limit).collect{|e| e}
    assert_equal days.flatten, cron_days
  end
  
end
