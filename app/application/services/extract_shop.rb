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
        recommend_drink = Repository::Shops.find_recommend_drink(shopid)

        # dirty code below , because recommend_drink is string... should be Success
        return Failure(Response::ApiResult.new(status: :ok, message: recommend_drink)) unless recommend_drink.empty?

        # Success(Response::ApiResult.new(status: :ok, message: temp_recommend_drink))
        Messaging::Queue
          .new(App.config.EXTRACT_QUEUE_URL, App.config)
          .send(input[:shop_id])

        Failure(Response::ApiResult.new(status: :processing, message: { request_id: input[:request_id] }))
      end
    end
  end
end
