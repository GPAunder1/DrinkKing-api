# frozen_string_literal: true

require 'dry/transaction'
require_relative 'helpers/shop_parser'
require_relative 'helpers/shop_finder'

module DrinkKing
  module Service
    # Extract values(ex:recommend drink) from shop
    class ExtractShop
      include Dry::Monads::Result::Mixin

      def call(input)
        shopid = input[:shop_id]
        recommend_drink = DrinkKing::Mapper::ReviewsExtractionMapper.find_by_shopid(shopid).recommend_drink
        Success(Response::ApiResult.new(status: :ok, message: recommend_drink))
      end
    end
  end
end
