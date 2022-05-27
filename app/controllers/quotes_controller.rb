class QuotesController < ApplicationController
  def generated
    @item = Item.find(params[:item])
    @quotes = QuoteCreator.call(@item, params[:distance])
  end
end
