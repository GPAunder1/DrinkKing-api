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
        ostruct_shop = to_openstruct(@shop)
        ostruct_shop.recommend_drink = @recommend_drink
        ostruct_shop.menu = to_openstruct(@menu)

        ostruct_shop
      end

      # nested openstruct
      def to_openstruct(hash)
        JSON.parse(hash.to_json, object_class: OpenStruct)
      end
    end
  end
end
