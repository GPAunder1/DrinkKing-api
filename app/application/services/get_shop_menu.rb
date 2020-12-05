# frozen_string_literal: true

require 'dry/transaction'
require_relative 'helpers/shop_parser'
require_relative 'helpers/shop_finder'

module DrinkKing
  module Service
    # ShopMenu Service class
    class ShopMenu
      include Dry::Monads::Result::Mixin

      def call(input)
        keyword = input[:keyword]
        searchby = input[:searchby]
        menu = ShopFinder.new(keyword, searchby).find
        Success(Response::ApiResult.new(status: :ok, message: menu))
      end
    end
  end
end
