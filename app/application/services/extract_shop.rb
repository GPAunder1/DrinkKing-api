# frozen_string_literal: true

require 'dry/transaction'
require_relative 'helpers/shop_parser'
require_relative 'helpers/shop_finder'

module DrinkKing
  module Service
    # Extract values(ex:recommend drink) from shop
    class ExtractShop
      include Dry::Monads::Result::Mixin

      PROCESSING_MSG = 'Processing the request'

      def call(input)
        shopid = input[:shop_id]
        recommend_drink = Repository::Shops.find_recommend_drink(shopid)
        return Success(Response::ApiResult.new(status: :ok, message: recommend_drink)) unless recommend_drink.empty?

        # Success(Response::ApiResult.new(status: :ok, message: temp_recommend_drink))
        Messaging::Queue
          .new(App.config.EXTRACT_QUEUE_URL, App.config)
          .send(extract_request_json(input))

        Failure(Response::ApiResult.new(status: :processing, message: PROCESSING_MSG))
      end

      # helper method
      def extract_request_json(input)
        Response::ExtractRequest.new(input[:shop_id], input[:request_id])
          .then { Representer::ExtractionRequest.new(_1) }
          .then(&:to_json)
      end
    end
  end
end
