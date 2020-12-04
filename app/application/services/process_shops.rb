# frozen_string_literal: true

require 'dry/transaction'
require_relative 'helpers/shop_parser'
require_relative 'helpers/shop_finder'

module DrinkKing
  module Service
    # Transaction to process shops(extract shop reviews to get recommend drink, get menu)
    class ProcessShops
      include Dry::Transaction

      step :find_shops_in_menu
      step :get_shops_from_database
      step :get_menu
      step :get_recommend_drink
      step :parse_to_shop_list

      def find_shops_in_menu(input)
        shopname_list = []
        # ===to be implement=== find shop in menu
        # shopname_list = ShopFinder.new(input[:search_keyword])
        input[:shopname_list] = []
        input[:shopname_list] << input[:search_keyword]
        Success(input)
      rescue StandardError => error
        Failure(Response::ApiResult.new(status: :internal_error, message: error.to_s))
      end

      def get_shops_from_database(input)
        input[:shops] = Repository::For.klass(Entity::Shop).find_many_shops(input[:shopname_list])

        if input[:shops][0].nil?
          Failure(Response::ApiResult.new(status: :no_content, message: 'No shop is found!'))
        else
          Success(input)
        end
      rescue StandardError => error
        # Failure(Response::ApiResult.new(status: :internal_error, message: error.to_s))
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Having trouble accessing the database'))
      end

      def get_menu(input)
        file = File.read('./assets/shops_menu.json')
        temp_menu = JSON.parse(file)[27]

        input[:menus] = []
        input[:shops].map do |shop|
          # menu = GetShopMenu.new(shopname).call.value!
          input[:menus] << temp_menu
        end

        Success(input)
      rescue StandardError => error
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Error with getting menu'))
      end

      def get_recommend_drink(input)
        input[:recommend_drinks] = []
        input[:shops].map do |shop|
          recommend_drink = Mapper::ReviewsExtractionMapper.find_by_shopname(shop.name).recommend_drink
          input[:recommend_drinks] << recommend_drink
        end

        Success(input)
      rescue StandardError => e
        Failure(Response::ApiResult.new(status: :internal_error, message: 'Error with getting recommend drink'))
      end

      def parse_to_shop_list(input)
        shops_list = []
        input[:shops].map.with_index do |shop, i|
          shops_list << ShopParser.new(shop, input[:recommend_drinks][i], input[:menus][i]).parse
        end
        shops_list = Response::ShopsList.new(shops_list)

        Success(Response::ApiResult.new(status: :ok, message: shops_list))
      end
    end
  end
end
