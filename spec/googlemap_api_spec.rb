require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/googlemap_api'

TOKEN = YAML.safe_load(File.read('../config/secrets.yml'))['api_token']

places = CodePraise::GooglemapApi.new(TOKEN).nearbyplaces("飲料", [24.7961217,120.9966699])
# places.map { |place| puts place.name }
place_name=[]

places.each{ |p| place_name << p.name }
puts place_name
