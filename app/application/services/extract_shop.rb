# frozen_string_literal: true

require 'dry/transaction'
require_relative 'helpers/shop_parser'
require_relative 'helpers/shop_finder'

module DrinkKing
  module Service
    # Extract values(ex:recommend drink) from shop
    class ExtractShop
      include Dry::Transaction

      step :check_input_validation
      step :get_recommand_drink

      def check_input_validation(input)
        shop_id = input[:shop_id].call
        if shop_id.success?
          Success(shop_id.value!)
        else
          Failure(Response::ApiResult.new(status: :bad_request, message: 'No Shop found'))
        end
      end

      def get_recommand_drink(input)
        #shop id ChIJj-JB7XI2aDQReyt7-6gXNXk
        recommend_drink = DrinkKing::Mapper::ReviewsExtractionMapper.find_by_shopid(input).recommend_drink
        Success(Response::ApiResult.new(status: :ok, message: recommend_drink))
      end

    end
  end
end
