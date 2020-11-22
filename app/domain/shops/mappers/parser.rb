# frozen_string_literal: true

module DrinkKing
  # to parse data from googlemapapi
  module Parsers
    # parse response to detect whether output is places array or error string
    class ApiResponse
      def initialize(response)
        @response = response
      end

      def apierror?
        @response.is_a?(String) ? false : true
      end
    end
  end
end
