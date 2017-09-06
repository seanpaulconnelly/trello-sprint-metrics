class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  def show
    @recent_days_client_work = DailyKanbanMetric.where(user: @user, metric_type: 1).last(14)
    @recent_days_bug_fixes = DailyKanbanMetric.where(user: @user, metric_type: 2).last(14)
    @recent_sprints_velocity = ArchivedMetric.includes(:sprint).where(user: @user).last(2)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

end
