class QuoteCreator < ApplicationService
  attr_reader :item, :distance

  def initialize(item, distance)
    @item = item
    @distance = distance
  end

  def call
    quotes = []

    ShippingCompany.where(status: 'active').each do |sc|
      deadline_query = sc.shipping_deadlines.where('start_distance <= ? AND end_distance >= ?', @distance,
                                                   @distance).first
      next unless deadline_query

      price_query =
        sc.shipping_prices.where('start_volume <= ? AND end_volume >= ? AND start_weight <= ? AND end_weight >= ?',
                                 @item.calc_volume, @item.calc_volume, @item.weight, @item.weight).first
      next unless price_query

      min_price_query = sc.min_shipping_prices.where('start_distance <= ? AND end_distance >= ?', @distance,
                                                     @distance).first
      price = price_query.calc_price(@distance.to_i)
      price = [price_query.calc_price(@distance.to_i), min_price_query.price].max if min_price_query
      quote = Quote.new(item: @item, shipping_company: sc, price: price, deadline: deadline_query.deadline)
      next unless quote.save

      quotes << quote
    end
    quotes.sort { |a, b| a.price <=> b.price }
  end
end
