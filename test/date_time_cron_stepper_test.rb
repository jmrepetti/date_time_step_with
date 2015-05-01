require 'time'
require 'minitest/autorun'
require 'date_time_step_with'

DateTime.include DateTimeStepWith::CronMatcher
DateTime.include DateTimeStepWith::CronStepper


class DateTimeCronStepperTest < Minitest::Test

  
  def test_minutes_collection
    date_time = DateTime.new(2015,4,1,0,0)
    date_time_limit = DateTime.new(2015,4,1,0,59)
    one_minute_step = (1.to_f/24/60)
    minutes = date_time.step(date_time_limit,one_minute_step).collect{|e| e}
    cron_minutes = date_time.step_with_cron("* * * * * *", date_time_limit).collect{|e| e}
    assert_equal minutes, cron_minutes
  end

  def test_minutes_list_collection
    date_time = DateTime.new(2015,4,1,0,0)
    date_time_limit = DateTime.new(2015,4,1,0,59)
    #sample list
    minutes = [3,7,9,10,25,30].collect {|e| DateTime.new(2015,4,1,0,e) }
    cron_minutes = date_time.step_with_cron("3,7,9,10,25,30 * * * * 2015", date_time_limit).collect{|e| e}
    assert_equal minutes, cron_minutes
  end

  def test_hours_list_collection
    date_time = DateTime.new(2015,4,1,0,0)
    date_time_limit = DateTime.new(2015,4,1,23,59)
    minutes = [3,7,9,10,16,23].collect {|e| DateTime.new(2015,4,1,e,0) }
    cron_minutes = date_time.step_with_cron("00 3,7,9,10,16,23 * * * 2015", date_time_limit).collect{|e| e}
    assert_equal minutes, cron_minutes
  end

  def test_minutes_range_collection
    date_time = DateTime.new(2015,4,1,0,0)
    date_time_limit = DateTime.new(2015,4,1,0,59)

    #sample list
    minutes = (3..30).collect {|e| DateTime.new(2015,4,1,0,e) }

    cron_minutes = date_time.step_with_cron("3-30 * * * * 2015", date_time_limit).collect{|e| e}
    assert_equal minutes, cron_minutes
  end

  def test_hours_range_collection
    date_time = DateTime.new(2015,4,1,0,0)
    date_time_limit = DateTime.new(2015,4,1,23,59)

    minutes = (3..16).collect {|e| DateTime.new(2015,4,1,e,0) }
    cron_minutes = date_time.step_with_cron("00 3-16 * * * 2015", date_time_limit).collect{|e| e}
    assert_equal minutes, cron_minutes
  end


  def test_cached_collection
    date_time = DateTime.new(2015,4,1,0,0)
    date_time_limit = DateTime.new(2015,4,1,0,59)

    cron_minutes = date_time.step_with_cron("* * * * * *", date_time_limit)
    cron_minutes_again = date_time.step_with_cron("* * * * * *", date_time_limit)

    assert_equal cron_minutes.object_id, cron_minutes_again.object_id
  end

  def test_no_cached_collection
    date_time = DateTime.new(2015,4,1,0,0)
    date_time_limit = DateTime.new(2015,4,1,0,59)

    cron_minutes = date_time.step_with_cron("* * * * * *", date_time_limit)
    cron_minutes_again = date_time.step_with_cron("* * * * * 2015", date_time_limit)

    refute_equal cron_minutes.object_id, cron_minutes_again.object_id
  end


  def test_step_minutes
    date_time = DateTime.new(2015,4,1,0,3)
    date_time_limit = DateTime.new(2015,4,1,0,16)

    one_minute_step = (1.to_f/24/60)

    minutes = (3..16).collect {|e| DateTime.new(2015,4,1,0,e) }

    cron_minutes = date_time.step_with_cron("* * * * * *", date_time_limit, one_minute_step)

    assert_equal minutes, cron_minutes
  end
  
  def test_step_hours
    
    date_time = DateTime.new(2015,4,1,3,0)
    date_time_limit = DateTime.new(2015,4,1,16,0)

    one_minute_step = (1.to_f/24)

    hours = (3..16).collect {|e| DateTime.new(2015,4,1,e,0) }

    cron_hours = date_time.step_with_cron("* * * * * *", date_time_limit, one_minute_step)

    assert_equal hours, cron_hours
  end
  

end
