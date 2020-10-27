# frozen_string_literal: true

require 'http'
require_relative 'nearbyplace'
require_relative 'parser'

module CodePraise
  # Library for googlemapAPI
  class GooglemapApi
    API_ROOT = 'https://maps.googleapis.com/maps/api'

    def initialize(token)
      @token = token
    end

    # request nearbysearch_api
    # parameter:location - an array contains with latitude and longitude
    def nearbyplaces(keyword, location)
      return 'Location must be an array.' unless location.is_a? Array

      picked_api = Prasers::ApiPicker.new('place', 'nearbysearch').pick
      nearbyplaces_response = Request.new(API_ROOT, @token).places(keyword, location, picked_api)
      Prasers::ApiResponseParser.new(nearbyplaces_response).map_place
    end

    # Sends out HTTP requests to GoogleMap
    class Request
      def initialize(root, token)
        @root = root
        @token = token
      end

      def places(keyword, location, picked_api)
        parameter = "location=#{location[0]},#{location[1]}&rankby=distance&keyword=#{keyword}&language=zh-TW"
        picked_url = "#{picked_api}/json?key=#{@token}&" + parameter
        call_api_url(picked_url)
      end

      def call_api_url(picked_url)
        # bad: divide url into three parts in order to pass reek :(
        url = "#{@root}/" + picked_url
        http_response = HTTP.get(url)
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
        api_statuscode == 'OK' ? parse : API_ERROR[api_statuscode]
      end
    end
  end
end
