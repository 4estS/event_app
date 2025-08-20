class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      # Always start a normal session
      session[:user_id] = user.id

      if ActiveModel::Type::Boolean.new.cast(params[:remember_me])
        token = user.remember!(ttl: 30.days)
        cookies.signed[:user_id] = {
          value: user.id,
          expires: 30.days.from_now,
          httponly: true,
          same_site: :lax,
          secure: request.ssl?
        }
        cookies[:remember_token] = {
          value: token,
          expires: 30.days.from_now,
          httponly: true,
          same_site: :lax,
          secure: request.ssl?
        }
      else
        # Ensure any old remember cookies are cleared if user chose not to remember this time
        user.forget! if user.remember_digest.present?
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
      end

      redirect_to home_path, notice: "Signed in!"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user
      current_user.forget!
    end
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
    session.delete(:user_id)
    redirect_to root_path, notice: "Signed out!"
  end
end
