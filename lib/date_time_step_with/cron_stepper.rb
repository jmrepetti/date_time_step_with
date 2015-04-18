module DateTimeStepWith
  module CronStepper
    def step_with_cron(cron_expression, limit)
      self.step(limit).select{|d| d.match_cron?(cron_expression) }.each
    end
  end
end
