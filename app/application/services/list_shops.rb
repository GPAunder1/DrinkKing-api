# frozen_string_literal: true

require 'dry/transaction'
require_relative 'helpers/shop_parser'
require_relative 'helpers/shop_finder'

module DrinkKing
  module Service
    # Transaction to process shops(extract shop reviews to get recommend drink, get menu)
    class ListShops
      include Dry::Transaction

      step :find_shops_in_menu
      step :get_shops_from_database
      step :parse_to_shop_list

      def find_shops_in_menu(input)
        shopname_list = ShopFinder.new(input[:search_keyword]).find_shopname
        input[:shopname_list] = shopname_list

        Success(input)
      rescue StandardError => error
        Failure(Response::ApiResult.new(status: :not_found, message: 'Error when finding shops in menu'))
      end

      def get_shops_from_database(input)
        input[:shops] = Repository::For.klass(Entity::Shop).find_many_shops(input[:shopname_list])

        if input[:shops][0].nil?
          Failure(Response::ApiResult.new(status: :not_found, message: 'No shop is found from database'))
        else
          Success(input)
        end
      rescue StandardError => error
        # Failure(Response::ApiResult.new(status: :internal_error, message: error.to_s))
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Having trouble accessing the database'))
      end

      def parse_to_shop_list(input)
        shops_list = []
        input[:shops].map do |shop|
          shops_list << ShopParser.new(shop).parse
        end
        shops_list = Response::ShopsList.new(shops_list)

        Success(Response::ApiResult.new(status: :ok, message: shops_list))
      end
    end
  end
end
