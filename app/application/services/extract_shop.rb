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
        check_extraction_done = false # 暫時的，之後會改成判斷資料庫中是否有recommend drink了
        Success(Response::ApiResult.new(status: :ok, message: recommend_drink)) if check_extraction_done

        # Messaging::Queue
        #   .new(App.config.CLONE_QUEUE_URL, App.config)
        #   .send(input[:shop_id])
        # 
        # Failure(Response::ApiResult.new(status: :processing, message: PROCESSING_MSG))

        shopid = input[:shop_id]
        recommend_drink = DrinkKing::Mapper::ReviewsExtractionMapper.find_by_shopid(shopid).recommend_drink
        Success(Response::ApiResult.new(status: :ok, message: recommend_drink))
      end
    end
  end
end
