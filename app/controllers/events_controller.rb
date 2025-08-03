class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [ :show, :edit, :update, :destroy ]

  def create
    @event = current_user.events.build(event_params)
    @event.status = params[:commit] == "Publish" ? :published : :draft

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
    @event.status = params[:commit] == "Publish" ? :published : :draft

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
    @event = current_user.events.new(starts_on: Date.current)
  end
  def edit
    @event = current_user.events.find_by!(slug: params[:slug])
  end

  private
  # app/controllers/events_controller.rb
  def set_event
    @event = Event.find_by!(slug: params[:slug])
  end

  def event_params
    params.require(:event).permit(:title, :description, :location_name, :location, :website_url, :event_type, :ticket_url, :category_id, :starts_on, :starts_at, :ends_at, :image, tag_ids: [])
  end

  def require_login
    redirect_to sign_in_path unless current_user
  end
end
