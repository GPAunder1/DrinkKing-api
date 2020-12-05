# frozen_string_literal: true

require 'dry/transaction'
require_relative 'helpers/shop_parser'
require_relative 'helpers/shop_finder'

module DrinkKing
  module Service
    # ShopMenu Service class
    class ShopMenu
      include Dry::Transaction

      step :check_input_validation
      step :get_shop_menu

      def check_input_validation(input)
        keyword = input[:keyword].call
        searchby = input[:searchby].call
        if keyword.success? && searchby.success?
          Success(input)
        else
          Failure(Response::ApiResult.new(status: :bad_request, message: 'No Shop found'))
        end
      end

      def get_shop_menu(input)
        keyword = input[:keyword].call.value!
        searchby = input[:searchby].call.value!
        menu = ShopFinder.new(keyword, searchby).find
        Success(Response::ApiResult.new(status: :ok, message: menu))
      end
    end
  end
end
