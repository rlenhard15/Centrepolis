class StagesController < ApplicationController

  # GET /stages
  def index
    @stages = Stage.all

    render json: @stages
  end
end
