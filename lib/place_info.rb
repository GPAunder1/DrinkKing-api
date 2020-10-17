# frozen_string_literal: true

require 'http'
require 'yaml'

config = YAML.safe_load(File.read('../config/secrets.yml'))

def api_type_picker(type)
  case type
  when 'place_findplace' then 'findplacefromtext'
  when 'place_nearbysearch' then 'nearbysearch'
  end
end

def api_path(config, type, path)
  "https://maps.googleapis.com/maps/api/place/#{api_type_picker(type)}/json?key=#{config['api_token']}&" + path
end

def call_api_url(url)
  HTTP.get(url)
end

results = []

findnearbyplaces_url = api_path(
  config,
  'place_nearbysearch',
  'location=24.7961217,120.9966699&rankby=distance&keyword=飲料&language=zh-TW'
)

response = call_api_url(findnearbyplaces_url).parse # convert httpresponse to hash
# response['status'] return the status code of response
places = response['results']

places.map do |place|
  result = {}
  result['name'] = place['name']
  result['address'] = place['vicinity']
  result['location'] = place['geometry']['location']
  result['open_now'] = place['opening_hours']['open_now'] unless place['opening_hours'].nil?
  result['rating'] = place['rating']
  results << result
end

File.write('../spec/fixtures/googlemap_results.yml', results.to_yaml)
