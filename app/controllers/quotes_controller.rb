class QuotesController < ApplicationController
  def generated
    @item = Item.find_by(sku: params[:i])
    @quotes = QuoteCreator.call(@item, params[:d])
  end
end
