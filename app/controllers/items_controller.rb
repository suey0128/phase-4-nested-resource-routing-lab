class ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  def index
    # items = Item.all
    # render json: items, include: :user
    if params[:user_id]
      user = find_user
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    item = Item.find(params[:id])
    render json: item, include: :user
  end

  def create
    user = find_user
    new_item = user.items.create!(item_params)
    render json: new_item, include: :user, status: :created
  end

  private
  def find_user
    User.find(params[:user_id])
  end

  def render_not_found_response
    render json:{error: "User not found"}, status: :not_found
  end

  def item_params
    params.permit(:name, :description, :price)
  end

  def render_unprocessable_entity_response(invalid)
    render json: { errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    # render json: { errors: invalid.record.errors }, status: :unprocessable_entity
  end

end
