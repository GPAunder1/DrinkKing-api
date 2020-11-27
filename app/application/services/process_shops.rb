# frozen_string_literal: true

require 'dry/transaction'

module DrinkKing
  module Service
    # Transaction to process shops(extract shop reviews to get recommend drink, get menu)
    class ProcessShops
      include Dry::Transaction

      step :get_shops_from_database
      step :get_menu
      step :get_recommend_drink

      def get_shops_from_database(input)
        input[:shops] = Repository::For.klass(Entity::Shop).find_shop(input[:search_keyword])

        input[:shops][0].nil? ? Failure('No shop is found!') : Success(input)
      rescue StandardError
        Failure('Having trouble accessing the database')
      end

      def get_menu(input)
        file = File.read('./app/domain/extraction/values/drinks.json')
        input[:menu] = JSON.parse(file)['drinks']

        input[:menu] == 'null' ? Failure('No menu is found') : Success(input)
      end

      def get_recommend_drink(input)
        input[:recommend_drinks] = []
        input[:shops].map do |shop|
          recommend_drink = Mapper::ReviewsExtractionMapper.find_by_shopname(shop.name).recommend_drink
          input[:recommend_drinks] << recommend_drink
        end

        Success(input)
      rescue StandardError => e
        puts e.to_s
        Failure('Error with getting recommend drink')
      end
    end
  end
end
