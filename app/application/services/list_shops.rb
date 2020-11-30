# frozen_string_literal: true

require 'dry/monads'

module DrinkKing
  module Service
    # Retrieves array of all listed shop entities
    class ListShops
      include Dry::Monads::Result::Mixin

      def call(search_word)
        shops = Repository::For.klass(Entity::Shop).find_many_shops(search_word)

        Success(shops)
      rescue StandardError
        Failure('Having trouble accessing the database')
      end
    end
  end
end
