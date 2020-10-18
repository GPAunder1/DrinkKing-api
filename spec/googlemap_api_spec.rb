# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/googlemap_api'

GARBLE = 'dcnisndisncsdc'
BAD_TOKEN = 'snidnsicndsivndsivdsv'
TOKEN = YAML.safe_load(File.read('../config/secrets.yml'))['api_token']
CORRECT = YAML.safe_load(File.read('./fixtures/googlemap_results.yml'))

describe 'Testing GooglemapApi Library' do
  describe 'Place information' do
    it 'checking the shop name' do
      places = CodePraise::GooglemapApi.new(TOKEN).nearbyplaces('飲料', [24.7961217, 120.9966699])
      _(places.size).must_equal CORRECT.size
    end

    it 'checking bad token' do
      _(CodePraise::GooglemapApi.new(BAD_TOKEN).nearbyplaces('飲料', [24.7961217, 120.9966699])).must_equal 'The provided API key is invalid.'
    end

    it 'checking no result' do
      _(CodePraise::GooglemapApi.new(TOKEN).nearbyplaces(GARBLE, [24.7961217, 120.9966699])).must_equal 'No result.'
    end

    it 'checking input error' do
      _(CodePraise::GooglemapApi.new(TOKEN).nearbyplaces(GARBLE, 120.9966699)).must_equal 'Location must be an array.'
    end
  end
end
