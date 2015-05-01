module DateTimeStepWith
  module CronStepper
    def step_with_cron(cron_expression, limit,step=nil, &block)

      #if no step given, then iterate on the minimum cron value
      if step.nil? && self.respond_to?(:minute)
        step = (1.to_f/24/60) #one minute
      else
        step = 1#one day
      end
      
      #Caching
      if (@step_with_cron_cache == "#{cron_expression} #{limit} #{step}")
        @step_with_cron_collection ||= self.step(limit,step).select{|d| d.match_cron?(cron_expression) }
      else
        @step_with_cron_cache = "#{cron_expression} #{limit} #{step}"
        @step_with_cron_collection = self.step(limit,step).select{|d| d.match_cron?(cron_expression) }
      end
      
      if block_given?
        @step_with_cron_collection.each do |d|
          yield d
        end
      else
        @step_with_cron_collection 
      end
    end
  end
end
