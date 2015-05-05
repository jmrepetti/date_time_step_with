module DateTimeStepWith
  
  module CronMatcher
    @@cron_re_exps = {}
    
    def match_cron?(cron_expression)
      @@cron_re_exps[cron_expression] ||= CronExpression.parse(cron_expression)      
      @@cron_re_exps[cron_expression].match_datetime?(self)      
    end
    
  end
  
end


