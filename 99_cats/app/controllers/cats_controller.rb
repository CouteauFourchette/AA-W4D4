class CatsController < ApplicationController
  before_action :prevent_non_owners, only: [:edit, :update]

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.includes(rental_requests: [:requester]).order('cat_rental_requests.start_date').find(params[:id])
    @owned = is_owner?
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    new_params = cat_params
    new_params[:user_id] = current_user.id
    @cat = Cat.new(new_params)
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    # @cat = Cat.find(params[:id])
    render :edit
  end

  def update
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  private

  def prevent_non_owners
    if logged_in?
      @cat = Cat.find(params[:id])
      redirect_to cat_url(params[:id]) unless is_owner?
    else
      redirect_to cat_url(params[:id])
    end
  end

  def is_owner?
    return false unless logged_in?
    current_user.cats.any? { |cat| cat.id == @cat.id }
  end

  def cat_params
    params.require(:cat).permit(:age, :birth_date, :color, :description, :name, :sex)
  end
end
