class DashboardController < ApplicationController
  before_action :authenticate_user!
  helper_method :current_user, :logged_in?
  def show
    @events = current_user.events.order(starts_at: :desc)
  end

  private

  def require_auth
    redirect_to root_path unless logged_in?
  end
end
