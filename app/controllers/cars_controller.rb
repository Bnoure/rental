class CarsController < ApplicationController
  before_action :set_search_params_and_dates, only: [:index]

  def index
    @cars = Car.all
    @booking = Booking.new

    return unless params[:search]

    @search_params = search_params.to_h
    if @search_params[:starts_date]
      @search_params[:starts_date], @search_params[:ends_date] = @search_params[:starts_date].split(' to ')
    end

    @cars = @cars.where(city: @search_params[:city]) if @search_params[:city].present?
    @cars = @cars.where(model: @search_params[:model]) if @search_params[:model].present?
    @cars = @cars.where(brand: @search_params[:brand]) if @search_params[:brand].present?
    session[:search] = @search_params
  end

  def show
    @car = Car.find(params[:id])
    @booking = Booking.new
    @search_params = params[:search] || {}
  end

  def destroy
    @car = Car.find(params[:id])
    @car.destroy
    redirect_to cars_path
  end

  private

  def set_search_params_and_dates
    return unless params[:search]

    @search_params = search_params.to_h
    if @search_params[:starts_date]
      start_date, end_date = @search_params[:starts_date].split(' to ')
      @search_params[:starts_date] = Date.strptime(start_date, "%d-%m-%Y") if start_date
      @search_params[:ends_date] = Date.strptime(end_date, "%d-%m-%Y") if end_date
      @start_date = @search_params[:starts_date]
      @end_date = @search_params[:ends_date]
    end
    session[:search] = @search_params
  end

  def search_params
    params.require(:search).permit(:city, :model, :brand, :starts_date, :ends_date)
  end
end
