module DateTimeStepWith
  module CronStepper
    def step_with_cron(cron_expression, limit,step=1)
      self.step(limit,step).select{|d| d.match_cron?(cron_expression) }.each
    end
  end
end
