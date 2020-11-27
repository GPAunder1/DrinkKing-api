# frozen_string_literal: true

require 'dry/transaction'

module DrinkKing
  module Service
    # Transaction to store shop from Googlemap Place API to database
    class AddShops
      include Dry::Transaction

      step :check_input_validation
      step :find_shops
      step :store_shops

      private

      def check_input_validation(input)
        if input.success?
          Success(input)
        else
          Failure(input.errors.messages.first.text)
        end
      end

      def find_shops(input)
        shops = shop_from_googlemap(input)
        Success(shops)
      rescue StandardError => error
        Failure(error.to_s)
      end

      def store_shops(input)
        shops = input.map { |shop| Repository::For.entity(shop).find_or_create(shop) }
        Success(shops)
      rescue StandardError => error
        Failure('Having trouble accessing the database')
      end

      # following are support methods that other services could use
      def shop_from_googlemap(input)
        response = Googlemap::ShopMapper.new(App.config.API_TOKEN).find(input[:search_keyword])
        if response.is_a? String
          Failure('Error with Gmap API: ' + response)
        else
          response
        end
      end
    end
  end
end
