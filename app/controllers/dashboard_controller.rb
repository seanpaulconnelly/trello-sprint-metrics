class DashboardController < ApplicationController
  before_action :require_login

  def show
    @last_two_weeks_client_stats = DailyKanbanMetric.where(metric_type:1).last(14)
    @last_two_weeks_bug_stats = DailyKanbanMetric.where(metric_type:2).last(14)
  end

  private

end
