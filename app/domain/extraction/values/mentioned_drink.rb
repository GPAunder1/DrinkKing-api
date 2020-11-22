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
        local_max = 0.55
        drink = 'not mentioned'
        characters.map do |character|
          @menu_list.map do |menu_item|
            similarity = String::Similarity.cosine character, menu_item
            # puts "#{character}\t#{menu_item}\t#{similarity}"
            if similarity > local_max
              drink = menu_item
              local_max = similarity
            end
          end
        end
        drink
      end
    end
  end
end
