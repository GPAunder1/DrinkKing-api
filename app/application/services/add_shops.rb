# frozen_string_literal: true

require 'dry/transaction'
require_relative 'helpers/shop_parser'
require_relative 'helpers/shop_finder'

module DrinkKing
  module Service
    # Transaction to store shop from Googlemap Place API to database
    class AddShops
      include Dry::Transaction

      step :check_input_validation
      step :find_shops_in_menu
      step :find_shops_from_googlemap
      step :store_shops

      private

      def check_input_validation(input)
        search_keyword = input[:search_keyword].call
        if search_keyword.success?
          Success(search_keyword.value!)
        else
          Failure(Response::ApiResult.new(status: :bad_request, message: 'Please enter keyword related to drink'))
        end
      end

      def find_shops_in_menu(input)
        shopname_list = ShopFinder.new(input).find_shopname

        if shopname_list.empty?
          Failure(Response::ApiResult.new(status: :not_found, message: 'No shop is found from menu'))
        else
          Success(shopname_list)
        end
      rescue StandardError => error
        Failure(Response::ApiResult.new(status: :internal_error, message: error.to_s))
      end

      def find_shops_from_googlemap(input)
        shops = []
        valid_error_message = 'No result'
        error_message = "Error with finding shops from googlemap"

        input.map do |shopname|
          api_result = shop_from_googlemap(shopname.split[0])
          if api_result.is_a?(String)
            error_message = api_result
          else
            api_result.map do |shop|
              shops << shop if shop.name.include? shopname
            end
          end
        end

        if shops.empty?
          Failure(Response::ApiResult.new(status: :not_found, message: error_message))
        else
          Success(shops)
        end
      rescue StandardError => error
        Failure(Response::ApiResult.new(status: :internal_error, message: error.to_s))
      end

      def store_shops(input)
        shops = input.map do |shop|
          entity_shop = Repository::For.entity(shop).find_or_create(shop)
          ShopParser.new(entity_shop).parse
        end
        shops = Response::ShopsList.new(shops)
        Success(Response::ApiResult.new(status: :created, message: shops))
      rescue StandardError => error
        Failure(Response::ApiResult.new(status: :internal_error, message: error.to_s))
      end

      # following are support methods that other services could use
      def shop_from_googlemap(input)
        response = Googlemap::ShopMapper.new(App.config.API_TOKEN).find(input)
        if response.is_a? String
          error_message = 'Error with Gmap API: ' + response
          error_message
        else
          response
        end
      end
    end
  end
end
