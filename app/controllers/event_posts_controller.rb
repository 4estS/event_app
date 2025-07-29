class EventPostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event_post, only: [ :show, :edit, :update, :destroy ]

  def index
    @event_posts = current_user.event_posts.order(starts_at: :asc)
  end

  def show
    respond_to do |format|
      format.html # renders show.html.erb
    end
  end

  def new
    @event_post = current_user.event_posts.new
  end

  def create
    @event_post = current_user.event_posts.new(event_post_params)
    if @event_post.save
      redirect_to @event_post, notice: "Event was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @event_post.update(event_post_params)
      redirect_to @event_post, notice: "Event was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event_post.destroy
    redirect_to event_posts_path, notice: "Event was deleted."
  end

  private

  def set_event_post
    @event_post = current_user.event_posts.find(params[:id])
  end

  def event_post_params
    params.require(:event_post).permit(:title, :description, :starts_at, :ends_at)
  end

  def require_login
    redirect_to sign_in_path unless current_user
  end
end
