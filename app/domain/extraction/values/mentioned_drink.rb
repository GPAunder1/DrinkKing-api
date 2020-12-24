# frozen_string_literal: false

require 'json'
require 'string-similarity'
require 'set'

module DrinkKing
  # Value Module
  module Value
    class DrinkGrappler
      def initialize
        file = File.read('./app/domain/extraction/values/drinks.json')
        obj = JSON.parse(file)
        drinks = obj['drinks']
        @menu_list = drinks.map { |drink| drink['name'] }
      end
      def mention_drink(characters)
        selected_mention_drink = characters.select { |_, pos| pos == 'DRINK_NOUN' }.keys[0]
        return 'not mentioned' if selected_mention_drink.nil?
        selected_mention_drink
      end
    end
  end
end
