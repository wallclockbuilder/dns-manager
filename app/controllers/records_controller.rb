class RecordsController < ApplicationController
  #GET /zones/:zone_id/records
  before_action :load_zone
  before_action :load_zone_record, only: [:show, :update, :destroy]

  def index
    render json: @zone.records, status: 200
  end

  def show
    render json: @record, status: 200
  end

  def create
    @zone.records.create!(record_params)
    render json: @zone, status: :created
  end

  def update
    @record.update(record_params)
    head :no_content
  end

  def destroy
    @record.destroy
    head :no_content
  end

  private
  def record_params
    params.permit(:name, :record_type, :record_data, :ttl)
  end

  def load_zone
    @zone = Zone.find(params[:zone_id])
  end

  def load_zone_record
    @record = @zone.records.find_by!(id: params[:id]) if @zone
  end
end
