class GuestLocationsController < ApplicationController
  def new
  end

  def create
    if params[:location].present?
      session[:guest_location] = params[:location]
      cookies[:guest_location] = { value: params[:location], expires: 1.year.from_now }
      redirect_to home_path, notice: "Location set."
    else
      redirect_to new_guest_location_path, alert: "Please enter a location."
    end
  end

  def destroy
    session.delete(:guest_location)
    cookies.delete(:guest_location)
    redirect_to root_path, notice: "Location reset."
  end

  private

  def redirect_if_location_missing_or_guest
    if cookies[:guest_location].blank? || !user_signed_in?
      redirect_to guest_location_index_path, alert: "Please enter a location."
    end
  end
end
