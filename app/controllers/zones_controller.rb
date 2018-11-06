class ZonesController < ApplicationController
  before_action :load_zone, only: [:show, :update, :destroy]

 # GET /zones
 def index
   @zones = Zone.all
   render json: @zones, status: 200
 end

 def show
   render json: @zone, status: 200
 end

 def create
   @zone = Zone.create!(zone_params)
   render json: @zone, status: :created
 end

 def update
   @zone.update(zone_params)
   head :no_content
 end

 def destroy
   @zone.destroy
   head :no_content
 end

  private
  def zone_params
    params.permit(:name)
  end

  def load_zone
    @zone = Zone.find(params[:id])
  end
end
