# frozen_string_literal: true

require 'http'
require 'yaml'

config = YAML.safe_load(File.read('../config/secrets.yml'))
#print config['api_token']

def api_path(config, type, path)
  #case type:
end
def api_place_path(config, path)
  "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?key=#{config['api_token']}&" + path
end

def api_nearbyplaces_path(config, path)
  "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=#{config['api_token']}&" + path
end
def call_api_url(config, url)
  HTTP.get(url)
end

response = {}
results = []

findplace_url = api_place_path(config, 'input=國立清華大學&inputtype=textquery&language=zh-TW&fields=place_id')
findnearbyplaces_url = api_nearbyplaces_path(config, 'location=24.7961217,120.9966699&radius=10&keyword=飲料&language=zh-TW')
response = call_api_url(config, findnearbyplaces_url).parse #convert httpresponse to hash
statuscode = response['status'] #ex: 200 OK
places = response['results']

places.map do |place|
  result = {}
  result['name'] = place['name']
  result['address'] = place['vicinity']
  result['location'] = place['geometry']['location']
  result['open_now'] = place['opening_hours']['open_now']
  result['rating'] = place['rating']
  results << result
end

File.write('../spec/fixtures/googlemap_results.yml', results.to_yaml)
