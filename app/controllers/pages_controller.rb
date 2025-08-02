class PagesController < ApplicationController
  before_action :require_location_or_auth, except: [ :index ]

  helper_method :current_user, :logged_in?
  def index
    redirect_to home_path if logged_in_or_has_location?
  end
  def home
    @events = Event.published.order(created_at: :desc)
  end

  def store_guest_location
    session[:guest_location] = params[:location]
    redirect_to home_path
  end

  private

  def require_location_or_auth
    redirect_to root_path unless logged_in_or_has_location?
  end

  def logged_in_or_has_location?
    current_user.present? || session[:guest_location].present? || cookies[:guest_location].present?
  end
end
