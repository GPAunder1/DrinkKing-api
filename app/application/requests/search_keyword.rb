# frozen_string_literal: true

require 'dry/monads/result'
require 'json'

module DrinkKing
  module Request
    # prase keyword request
    class SearchKeyword
      include Dry::Monads::Result::Mixin

      def initialize(params)
        @params = params
      end

      def call
        Success(
          @params
        )
      rescue StandardError
        Failure(
          Response::ApiResult.new(status: :bad_request, message: 'keyword not found')
        )
      end
    end
  end
end
