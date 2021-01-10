# frozen_string_literal: true

require_relative 'shops_representer'
require_relative 'menu_representer'
require_relative 'http_response_representer'
require_relative 'shops_page_representer'
module DrinkKing
  module Representer
    # Returns appropriate representer for response object
    class For
      REP_KLASS = {
        Response::ShopsList => ShopsList,
        # Entity::Shop        => Shop,
        # String              => HttpResponse
        Response::ShopsPage => ShopsPage
      }.freeze

      attr_reader :status_rep, :body_rep

      def initialize(result)
        if result.failure?
          @status_rep = Representer::HttpResponse.new(result.failure)
          @body_rep = @status_rep
        else
          value = result.value!
          @status_rep = Representer::HttpResponse.new(value)
          if REP_KLASS[value.message.class].nil?
            @body_rep = value.message
          else
            @body_rep = REP_KLASS[value.message.class].new(value.message)
          end
        end
      end

      def http_status_code
        @status_rep.http_status_code
      end

      def to_json(*args)
        @body_rep.to_json(*args)
      end

      def status_and_body(response)
        response.status = http_status_code
        to_json
      end
    end
  end
end
