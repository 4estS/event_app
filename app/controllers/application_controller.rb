class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user, :logged_in?

  private

  def current_user
    # Return memoized value if we’ve computed it
    return @current_user if defined?(@current_user)

    # 1) Prefer the session (standard login)
    if (uid = session[:user_id])
      @current_user = User.find_by(id: uid)
      return @current_user
    end

    # 2) Fallback: Remember-me cookies
    uid   = cookies.signed[:user_id]
    token = cookies[:remember_token]
    if uid && token
      user = User.find_by(id: uid)
      if user && user.remembered?(token) && !user.remember_expired?(ttl: 30.days)
        # Re-hydrate the session for subsequent requests
        session[:user_id] = user.id
        @current_user = user
        return @current_user
      end
    end

    @current_user = nil
  end

  def logged_in?
    current_user.present?
  end

  def authenticate_user!
    redirect_to sign_in_path, alert: "Please log in" unless logged_in?
  end
end
