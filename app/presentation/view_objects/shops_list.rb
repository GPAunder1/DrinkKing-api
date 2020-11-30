# frozen_string_literal: true

module Views
  # View for shop_lists
  class ShopsList
    def initialize(shops, recommend_drinks = nil, menu = nil)
      unless recommend_drinks.nil?
        @shops = shops.map.with_index { |shop, i| Shop.new(shop, recommend_drinks[i], menu) }
      else
        @shops = shops.map { |shop| Shop.new(shop) }
      end
    end

    def each
      @shops.each do |shop|
        yield shop
      end
    end
  end
end
