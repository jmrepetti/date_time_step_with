require 'time'
require 'minitest/autorun'
require 'date_time_step_with'

Time.include DateTimeStepWith::CronMatcher
Date.include DateTimeStepWith::CronMatcher
DateTime.include DateTimeStepWith::CronMatcher

class CronMatcherTest < Minitest::Test

  def test_match_dates
    date = Date.new(2015,4,1)
    cr_exp = "* * 1 * * *"
    assert (date.match_cron? cr_exp), "#{date} should match '#{cr_exp}'"
    date = Date.new(2015,4,11)    
    assert !(date.match_cron? cr_exp), "#{date} should not match '#{cr_exp}'"    
    date = Date.new(2015,4,1)    
    cr_exp = "* * 01 * * *"    
    assert (date.match_cron? cr_exp), "#{date} should match '#{cr_exp}'"        
    date = Date.new(2015,3,15)
    cr_exp = "00 00 * * * *"    
    assert (date.match_cron? cr_exp), "#{date} should match '#{cr_exp}'"        
    date = DateTime.new(2015,3,15)
    cr_exp = "00 00 * * * *"    
    assert (date.match_cron? cr_exp), "#{date} should match '#{cr_exp}'"        
    date = DateTime.new(2015,3,15)
    cr_exp = "00 00 * 4 * 2015"    
    assert !(date.match_cron? cr_exp), "#{date} should not match '#{cr_exp}'"        
  end

  def test_minutes_range
    date_time = DateTime.new(2015,1,1,12,20)
    date_time_limit = DateTime.new(2015,1,1,12,35)
    cr_exp = "20-35 12 * * * 2015"    
    min_step = 1.0/(24*60)
    date_time.step(date_time_limit, min_step).each do |d|
      assert (d.match_cron? cr_exp), "#{d} should match '#{cr_exp}'"
    end
    date_time = DateTime.new(2015,1,1,12,19)
    assert !(date_time.match_cron? cr_exp), "#{date_time} should not match '#{cr_exp}'"    
    date_time = DateTime.new(2015,1,1,12,36)
    assert !(date_time.match_cron? cr_exp), "#{date_time} should not match '#{cr_exp}'"    
  end
  
  def test_hours_range
    date_time = DateTime.new(2015,1,1,12,20)
    date_time_limit = DateTime.new(2015,1,1,18,35)
    cr_exp = "* 12-18 * * * 2015"
    hour_step = 1.0/(24)
    date_time.step(date_time_limit, hour_step).each do |d|
      assert (d.match_cron? cr_exp), "#{d} should match '#{cr_exp}'"
    end
    date_time = DateTime.new(2015,1,1,11,19)
    assert !(date_time.match_cron? cr_exp), "#{date_time} should not match '#{cr_exp}'"
    date_time = DateTime.new(2015,1,1,19,36)
    assert !(date_time.match_cron? cr_exp), "#{date_time} should not match '#{cr_exp}'"
  end
  
  def test_minutes_list
    date_time = DateTime.new(2015,1,1,12,21)
    date_time_limit = DateTime.new(2015,1,1,12,24)
    cr_exp = "21,22,23,24 12 * * * 2015"    
    min_step = 1.0/(24*60)
    date_time.step(date_time_limit, min_step).each do |d|
      assert (d.match_cron? cr_exp), "#{d} should match '#{cr_exp}'"
    end
    date_time = DateTime.new(2015,1,1,12,20)
    assert !(date_time.match_cron? cr_exp), "#{date_time} should not match '#{cr_exp}'"    
    date_time = DateTime.new(2015,1,1,12,25)
    assert !(date_time.match_cron? cr_exp), "#{date_time} should not match '#{cr_exp}'"    
  end

  def test_hours_list
    date_time = DateTime.new(2015,1,1,12,20)
    date_time_limit = DateTime.new(2015,1,1,15,35)
    cr_exp = "* 12,13,14,15 * * * 2015"
    hour_step = 1.0/(24)
    date_time.step(date_time_limit, hour_step).each do |d|
      assert (d.match_cron? cr_exp), "#{d} should match '#{cr_exp}'"
    end
    date_time = DateTime.new(2015,1,1,11,19)
    assert !(date_time.match_cron? cr_exp), "#{date_time} should not match '#{cr_exp}'"
    date_time = DateTime.new(2015,1,1,16,36)
    assert !(date_time.match_cron? cr_exp), "#{date_time} should not match '#{cr_exp}'"
  end
  
  def test_every_minute
    (0..59).to_a.each do |minute|
      date_time = DateTime.new(2015,1,1,1,minute)
      minutes = "%02d" % minute    
      cr_exp = "#{minutes} 01 1 1 * 2015"
      assert (date_time.match_cron? cr_exp), "#{date_time} should match '#{cr_exp}'"
    end  
  end
  
  def test_every_hour
    (0..23).to_a.each do |h|
      date_time = DateTime.new(2015,1,1,h,0)
      hs = "%02d" % h    
      cr_exp = "* #{hs} 1 1 * 2015"
      assert (date_time.match_cron? cr_exp), "#{date_time} should match '#{cr_exp}'"
    end  
  end

  def test_every_day_time
    (1..31).to_a.each do |d|
      date_time = DateTime.new(2015,1,d,0,0)
      ds = "%02d" % d    
      cr_exp = "* * #{ds} 1 * 2015"
      assert (date_time.match_cron? cr_exp), "#{date_time} should match '#{cr_exp}'"
    end  
  end

  def test_every_day_date
    (1..31).to_a.each do |d|
      date = Date.new(2015,1,d)
      ds = "%02d" % d    
      cr_exp = "* * #{ds} 1 * 2015"
      assert (date.match_cron? cr_exp), "#{date} should match '#{cr_exp}'"
    end  
  end


  def test_every_month_time
    (1..12).to_a.each do |m|
      date_time = DateTime.new(2015,m,1,0,0)
      ms = "%02d" % m    
      cr_exp = "* * * #{ms} * 2015"
      assert (date_time.match_cron? cr_exp), "#{date_time} should match '#{cr_exp}'"
    end  
  end
  
  def test_every_month_date
    (1..12).to_a.each do |m|
      date = Date.new(2015,m,1)
      ms = "%02d" % m    
      cr_exp = "* * * #{ms} * 2015"
      assert (date.match_cron? cr_exp), "#{date} should match '#{cr_exp}'"
    end  
  end

  def test_ten_years_time
    (2015..2025).to_a.each do |y|
      date_time = DateTime.new(y,1,1,0,0)
      ys = "%02d" % y    
      cr_exp = "* * * * * #{ys}"
      assert (date_time.match_cron? cr_exp), "#{date_time} should match '#{cr_exp}'"
    end  
  end

  def test_ten_years_date
    (2015..2025).to_a.each do |y|
      date = Date.new(y,1,1)
      ys = "%02d" % y    
      cr_exp = "* * * * * #{ys}"
      assert (date.match_cron? cr_exp), "#{date} should match '#{cr_exp}'"
    end  
  end

  def test_match_specific_date_time
    cr_exp = "* * 1 4 * 2015"
    date_time = DateTime.new(2015,4,1)
    assert (date_time.match_cron? cr_exp), "#{date_time} should not match '#{cr_exp}'"
  end


  def test_not_match_specific_date_time
    cr_exp = "* * 1 5 * 2015"
    date_time = DateTime.new(2015,4,1)
    assert !(date_time.match_cron? cr_exp), "#{date_time} should not match '#{cr_exp}'"
  end


  def test_match_every_day
    cr_exp = "* * * * * 2015"

    date = Date.new(2015,4,1)

    date.step(Date.new(2015,4,30)).each do |d|
      assert (d.match_cron? cr_exp), "#{d} should match '#{cr_exp}'"
    end
  end

  def test_not_match_not_every_day
    cr_exp = "* * * * * 2016"
    date = Date.new(2015,4,1)

    date.step(Date.new(2015,4,30)).each do |d|
      assert !(d.match_cron? cr_exp), "#{d} should not match '#{cr_exp}'"
    end
  end


  ["sunday","monday","tuesday","wednesday","thursday","friday","saturday"].each_with_index do |day,idx|
    define_method "test_match_every_#{day}" do
      cr_exp = "* * * * #{idx} 2015"
      date = Date.new(2015,1,1)
      days = date.step(Date.new(2015,12,31)).select { |d| d.send("#{day}?") }
      days.each do |d|
        assert (d.match_cron? cr_exp), "#{day}: #{d} should match #{cr_exp}"
      end
    end
  end
  
  
end


