# frozen_string_literal: true

module CodePraise
  # to prase common things about googlemapapi
  module Prasers
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
          end
        end
      end
    end

    # parse response to detect whether output is places array or error string
    class ApiResponseParser
      def initialize(response)
        @response = response
      end

      def map_place
        if @response.is_a? String
          raise_error
        else
          @response['results'].map { |place_data| Nearbyplace.new(place_data) }
        end
      end

      def raise_error
        @response
      end
    end
  end
end
