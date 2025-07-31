class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [ :show, :edit, :update, :destroy ]

  def create
    @event = current_user.events.build(event_params)

    if @event.save
      @events = Event.order(created_at: :desc)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to dashboard_path, notice: "Event was successfully created." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end
  def update
    if @event.update(event_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to dashboard_path, notice: "Event updated." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    @event.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to dashboard_path, notice: "event deleted." }
    end
  end

  def index
    @events = current_user.events.order(starts_at: :asc)
  end
  def show
    respond_to do |format|
      format.html # renders show.html.erb
    end
  end
  def new
    @event = current_user.events.new
  end
  def edit
    @event = current_user.events.find(params[:id])
  end

  private

  def set_event
    @event = current_user.events.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :category_id, :starts_at, :ends_at)
  end

  def require_login
    redirect_to sign_in_path unless current_user
  end
end
