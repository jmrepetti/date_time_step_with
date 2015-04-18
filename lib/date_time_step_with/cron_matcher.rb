module DateTimeStepWith

  # Copied from http://en.wikipedia.org/wiki/Cron
  # * * * * *  
  # │ │ │ │ │ 
  # │ │ │ │ │ 
  # │ │ │ │ └───── day of week (0 - 6) (0 to 6 are Sunday to Saturday, or use names; 7 is Sunday, the same as 0)
  # │ │ │ └────────── month (1 - 12)
  # │ │ └─────────────── day of month (1 - 31)
  # │ └──────────────────── hour (0 - 23)
  # └───────────────────────── min (0 - 59)
  class CronRangeMatcher
    def initialize(cron_expression)
      from, to = cron_expression.split("-")
      @range = (from..to).to_a
    end
    
    def =~(value)
      @range.include? value
    end
    
  end

  class CronListMatcher
    def initialize(cron_expression)
      @list = cron_expression.split(",")
    end
    
    def =~(value)
      @list.include? value
    end
  end

  module CronMatcherDateMethods
    def self_cron_array
      %W(0 0 #{self.day} #{self.month} #{self.wday} #{self.year})
    end
  end

  module CronMatcherTimeMethods
    def self_cron_array 
      %W(#{self.min} #{self.hour} #{self.day} #{self.month} #{self.wday} #{self.year})
    end
  end

  
  module CronMatcher
    @@cron_re_exps = {}
    
    def self.included(klass)
      if (klass == Date)
        klass.include CronMatcherDateMethods
      else
        klass.include CronMatcherTimeMethods        
      end   
    end
    
    def match_cron?(cron_expression)
      
      @@cron_re_exps[cron_expression] ||= cron_expression.split(/\s/).collect {|cr_exp|
      
        if (cr_exp == "*")
          /.*/
        elsif cr_exp["-"]
          CronRangeMatcher.new(cr_exp) 
        elsif cr_exp[","]
          CronListMatcher.new(cr_exp) 
        else
          Regexp.new("^#{cr_exp.to_i}$")
        end
      }
      
      self_cron_array.zip(@@cron_re_exps[cron_expression]).all? do |value, cr_exp|
        cr_exp =~ value
      end
  
    end
    
  end
  



  
end


