class QuotesController < ApplicationController
  before_action :authenticate_admin!

  def generated
    distance = params[:d]
    @item = Item.find_by(sku: params[:i])
    @quotes = QuoteCreator.call(@item, distance)
  end

  def index
    @quotes = Quote.order(created_at: :desc)
  end
end
