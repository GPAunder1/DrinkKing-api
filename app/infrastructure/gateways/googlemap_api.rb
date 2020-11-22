# frozen_string_literal: true

require_relative 'picker'

module DrinkKing
  module Googlemap
    ## Library for googlemapAPI
    class Api
      def initialize(token)
        @token = token
      end

      # request nearbysearch_api
      # parameter:location - an array contains with latitude and longitude
      def nearbyplaces_data(keyword, location)
        picked_api = Picker::ApiPicker.new('place', 'nearbysearch').pick
        Request.new(@token).places(keyword, location, picked_api)
      end

      def placedetails_data(placeid)
        picked_api = Picker::ApiPicker.new('place', 'placedetails').pick
        Request.new(@token).placedetails(placeid, picked_api)
      end

      # Sends out HTTP requests to GoogleMap
      class Request
        API_ROOT = 'https://maps.googleapis.com/maps/api'

        def initialize(token)
          @token = token
        end

        def places(keyword, location, picked_api)
          parameter = "location=#{location[0]},#{location[1]}&radius=1500&keyword=#{keyword}&language=zh-TW"
          url = get_request_url(picked_api, parameter)
          call_api_url(url)
        end

        def placedetails(placeid, picked_api)
          parameter = "place_id=#{placeid}&language=zh-TW"\
                      '&fields=formatted_address,formatted_phone_number,opening_hours,reviews,url'
          url = get_request_url(picked_api, parameter)
          call_api_url(url)
        end

        def get_request_url(picked_api, parameter)
          "#{API_ROOT}/#{picked_api}/json?key=#{@token}&#{parameter}"
        end

        def call_api_url(url)
          http_response = HTTP.headers(
            'Authorization' => "token #{@token}"
          ).get(url)
          Response.new(http_response).tap do |response|
            return response.successful?
          end
        end
      end

      # Decorates HTTP and API responses from GoogleMap with success/error
      class Response < SimpleDelegator
        HTTP_ERROR = {
          404 => 'HTTP Not Found.'
        }.freeze

        API_ERROR = {
          'ZERO_RESULTS' => 'No result.',
          'OVER_QUERY_LIMIT' => 'API request is over quota.',
          'REQUEST_DENIED' => 'The provided API key is invalid.',
          'INVALID_REQUEST' => 'The query parameter is missing.',
          'UNKNOWN_ERROR' => 'Unknown Error.'
        }.freeze

        def successful?
          return HTTP_ERROR[code] unless code == 200

          api_statuscode = parse['status']
          api_statuscode == 'OK' ? parse['results'] || parse['result'] : API_ERROR[api_statuscode]
        end

        def self.error_message
          { 'HTTP_ERROR' => HTTP_ERROR,
            'API_ERROR' => API_ERROR }
        end
      end
    end
  end
end
