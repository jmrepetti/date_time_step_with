module DateTimeStepWith
  module CronStepper
    def step_with_cron(cron_expression, limit,step=1)
      collection = self.step(limit,step).select{|d| d.match_cron?(cron_expression) }
    def step_with_cron(cron_expression, limit,step=nil, &block)

      #if no step given, then iterate on the minimum cron value
      if step.nil? && self.respond_to?(:minute)
        step = (1.to_f/24/60) #one minute
      else
        step = 1#one day
      end
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
