module DateTimeStepWith  

  class CronExpression
    
    attr_accessor :minutes, :hours, :days, :months, :weekdays, :years
    
    def self.parse(expression)
      values = expression.split(/\s/).collect do |cr_exp|
        if (cr_exp == "*")
          CronWildcard.new
        elsif cr_exp["-"]
          CronRange.new(cr_exp)
        elsif cr_exp[","]
          CronList.new(cr_exp)
        else
          CronNumber.new(cr_exp)
        end
      end
      new(*values)
    end
    
    def initialize(minutes, hours, days, months, weekdays, years=nil)
      @minutes, @hours, @days, @months, @weekdays, @years = minutes, hours, days, months, weekdays, years
    end
    
    def cron_array
      [@minutes, @hours, @days, @months, @weekdays, @years]
    end
    
    def match_datetime?(value)
      if value.respond_to? :min
        match_time?(value)
      else
        match_date?(value)
      end
    end
    
    def match_date?(date)
      %W(0 0 #{date.day} #{date.month} #{date.wday} #{date.year}).zip(cron_array).all? do |value, cr_exp|
        cr_exp =~ value
      end
    end
    
    def match_time?(time)
      %W(#{time.min} #{time.hour} #{time.day} #{time.month} #{time.wday} #{time.year}).zip(cron_array).all? do |value, cr_exp|
        cr_exp =~ value
      end
    end
    
    class CronNumber
      def initialize(cron_expression)
        @value = cron_expression
      end

      def =~(value)
        Regexp.new("^#{@value.to_i}$") =~ value
      end
    end
    
    class CronWildcard  
      def =~(value)
        /.*/ =~ value
      end
    end
    
    class CronRange
      def initialize(cron_expression)
        from, to = cron_expression.split("-")
        @range = (from..to).to_a
      end
  
      def =~(value)
        @range.include? value
      end
  
    end

    class CronList
      def initialize(cron_expression)
        @list = cron_expression.split(",")
      end
  
      def =~(value)
        @list.include? value
      end
    end    
    
    
  end
end



# Copied from http://en.wikipedia.org/wiki/Cron
# * * * * *  
# │ │ │ │ │ 
# │ │ │ │ │ 
# │ │ │ │ └───── day of week (0 - 6) (0 to 6 are Sunday to Saturday, or use names; 7 is Sunday, the same as 0)
# │ │ │ └────────── month (1 - 12)
# │ │ └─────────────── day of month (1 - 31)
# │ └──────────────────── hour (0 - 23)
# └───────────────────────── min (0 - 59)


module CronMatcherDateMethods

end