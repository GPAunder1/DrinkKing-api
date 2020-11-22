# frozen_string_literal: true

# require 'yaml'
# require_relative 'googlemap_api'
require 'init'

CONFIG = YAML.safe_load(File.read('./config/secrets.yml'))
TOKEN = CONFIG['API_TOKEN']

results = []

places = DrinkKing::GooglemapApi.new(TOKEN).nearbyplaces('飲料', [24.7961217, 120.9966699])

places.map do |place|
  result = {}
  result['name'] = place.name
  result['address'] = place.address
  result['location'] = place.location
  result['open_now'] = place.opening_now
  result['rating'] = place.rating
  results << result
end
File.write('./spec/fixtures/googlemap_results.yml', results.to_yaml)
