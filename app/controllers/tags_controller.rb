# app/controllers/tags_controller.rb
class TagsController < ApplicationController
  def autocomplete
    @tags = Tag.where("name ILIKE ?", "%#{params[:q]}%").limit(10)
    render partial: "tags/autocomplete", formats: [ :turbo_stream ]
  end

  def show
    @tag = Tag.all.find { |t| t.to_param == params[:id] }
    raise ActiveRecord::RecordNotFound unless @tag

    @events = Event.where(id: EventTag.where(tag_id: @tag.id).select(:event_id))
                 .published
                 .includes(:category)  # only preload category
                 .order(starts_on: :asc, starts_at: :asc)
  end
end
