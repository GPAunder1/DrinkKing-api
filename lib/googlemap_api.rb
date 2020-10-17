# frozen_string_literal: true

require 'http'
require_relative 'nearbyplace'

module CodePraise
  # Library for googlemapAPI
  class GooglemapApi
    API_ROOT = 'https://maps.googleapis.com/maps/api'
    ERROR = {
      404 => 'HTTP Not Found.',
      'ZERO_RESULTS' => 'No result.',
      'OVER_QUERY_LIMIT' => 'API request is over quota.',
      'REQUEST_DENIED' => 'The provided API key is invalid.',
      'INVALID_REQUEST' => 'The query parameter is missing.',
      'UNKNOWN_ERROR' => 'Unknown Error.'
    }.freeze

    def initialize(token)
      @token = token
    end

    # request nearbysearch_api
    # parameter:location - an array contains with latitude and longitude
    def nearbyplaces(keyword, location)
      path = "location=#{location[0]},#{location[1]}&rankby=distance&keyword=#{keyword}&language=zh-TW"
      req_url = api_path('place', 'nearbysearch', path)
      nearbyplaces_data = call_api_url(req_url)
      if nearbyplaces_data.is_a? Hash
        nearbyplaces_data['results'].map { |place_data| Nearbyplace.new(place_data) }
      else
        nearbyplaces_data
      end
    end

    private

    def api_path(category, type, path)
      "#{API_ROOT}/#{api_picker(category, type)}/json?key=#{@token}&" + path
    end

    def api_picker(category, type)
      case category
      when 'place'
        case type
        when 'findplace' then 'place/findplacefromtext'
        when 'nearbysearch' then 'place/nearbysearch'
        end
      end
    end

    def call_api_url(url)
      result = HTTP.get(url)
      http_successful?(result) ? result : (return ERROR[result.code])

      result = result.parse
      api_successful?(result) ? result : ERROR[result['status']]
    end

    def http_successful?(result)
      result.code == 200
    end

    def api_successful?(result)
      api_statuscode = result['status']
      api_statuscode == 'OK'
    end
  end
end
# ----test code----
# require 'yaml'
# token = YAML.safe_load(File.read('../config/secrets.yml'))['api_token']
# test = CodePraise::GooglemapApi.new(token)
# places = test.nearbyplaces("飲料", [24.7961217, 120.9966699])
# puts places
# places.map { |place| puts place.name }
