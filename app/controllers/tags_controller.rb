# app/controllers/tags_controller.rb
class TagsController < ApplicationController
  def autocomplete
    @tags = Tag.where("name ILIKE ?", "%#{params[:q]}%").limit(10)
    render partial: "tags/autocomplete", formats: [ :turbo_stream ]
  end
end
