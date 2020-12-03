# frozen_string_literal: true

module DrinkKing
  module Service
    # fill empty field(recommend_drink, menu) to fit shop representer
    class ShopParser
      def initialize(shop, recommend_drink = nil, menu = nil)
        @shop = shop.to_h
        @recommend_drink = recommend_drink
        @menu = menu
      end

      def parse
        ostruct_shop = OpenStruct.new(@shop)
        ostruct_shop.recommend_drink = @recommend_drink
        ostruct_shop.menu = @menu
        ostruct_shop.reviews = ostruct_shop.reviews.map { | review | review = OpenStruct.new(review) }

        ostruct_shop
      end
    end
  end
end
