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
        @params != GARBLE ? Success(@params) : Failure(StandardError)
      rescue StandardError
        Failure(Response::ApiResult.new(status: :bad_request, message: 'Please enter keyword related to drink'))
      end
    end
  end
end
