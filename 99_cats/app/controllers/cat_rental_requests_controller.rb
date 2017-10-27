class CatRentalRequestsController < ApplicationController
  before_action :check_owned_cat, only: [:approve, :deny]

  def approve
    current_cat_rental_request.approve!
    redirect_to cat_url(current_cat)
  end

  def create
    new_params = cat_rental_request_params
    new_params[:user_id] = current_user.id
    @rental_request = CatRentalRequest.new(new_params)
    if @rental_request.save
      redirect_to cat_url(@rental_request.cat)
    else
      flash.now[:errors] = @rental_request.errors.full_messages
      render :new
    end
  end

  def deny
    current_cat_rental_request.deny!
    redirect_to cat_url(current_cat)
  end

  def new
    @rental_request = CatRentalRequest.new
  end

  def check_owned_cat
    if logged_in?
      redirect_to cat_url(params[:id]) unless current_user.cats.any? { |cat| cat.id == current_cat.id }
    else
      redirect_to cat_url(params[:id])
    end
  end

  private

  def current_cat_rental_request
    @rental_request ||=
      CatRentalRequest.includes(:cat).find(params[:id])
  end

  def current_cat
    current_cat_rental_request.cat
  end

  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :end_date, :start_date, :status)
  end
end
