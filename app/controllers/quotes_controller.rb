class QuotesController < ApplicationController
  before_action :authenticate_admin!

  def generated
    @item = Item.find_by(sku: params[:i])
    @quotes = QuoteCreator.call(@item, params[:d])
  end

  def index
    @quotes = Quote.order(created_at: :desc)
  end
end
