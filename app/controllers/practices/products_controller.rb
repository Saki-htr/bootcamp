# frozen_string_literal: true

class Practices::ProductsController < ApplicationController
  before_action :require_login

  def index
    @practice = Practice.find(params[:practice_id])
    @products = Product
                .includes(
                  :practice,
                  :comments,
                  :checks,
                  user: { avatar_attachment: :blob }
                )
                .where(practice: @practice)
                .order(created_at: :desc)
                .page(params[:page])
    @my_product = Product.where(practice: @practice).find_by(user: current_user)
  end
end
