# frozen_string_literal: false

require 'json'
require 'string-similarity'
require 'set'

module DrinkKing
  # Value Module
  module Value
    class DrinkGrappler
      def initialize
        # nothing to do right now
      end
      def mention_drink(characters)
        selected_mention_drink = characters.select { |_, pos| pos == 'DRINK_NOUN' }.keys[0]
        return 'not mentioned' if selected_mention_drink.nil?
        selected_mention_drink
      end
    end
  end
end
