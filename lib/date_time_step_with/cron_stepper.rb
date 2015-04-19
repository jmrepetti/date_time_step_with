module DateTimeStepWith
  module CronStepper
    def step_with_cron(cron_expression, limit,step=1)
      collection = self.step(limit,step).select{|d| d.match_cron?(cron_expression) }
      if block_given?
        collection.each do |d|
          yield d
        end
      else
        collection
      end
    end
  end
end
