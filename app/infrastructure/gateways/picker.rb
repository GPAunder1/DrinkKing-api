# frozen_string_literal: true

module DrinkKing
  # to prase common things about googlemapapi
  module Picker
    # to pick_api
    class ApiPicker
      def initialize(category, type)
        @category = category
        @type = type
      end

      def pick
        case @category
        when 'place'
          case @type
          when 'findplace' then 'place/findplacefromtext'
          when 'nearbysearch' then 'place/nearbysearch'
          when 'placedetails' then 'place/details'
          end
        end
      end
    end
  end
end
