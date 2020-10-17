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
  it 'checking the shop name' do
    places = CodePraise::GooglemapApi.new(TOKEN).nearbyplaces('飲料', [24.7961217, 120.9966699])
    puts places[0].name
    _(places[0].name).must_equal CORRECT[0]['name']
  end
  it 'checking bad token' do
    _(proc do
      CodePraise::GooglemapApi.new(BAD_TOKEN).nearbyplaces('飲料', [24.7961217, 120.9966699])
    end).must_raise CodePraise::GooglemapApi::ERROR::REQUEST_DENIED
  end

  it 'checking result' do
    _(proc do
      CodePraise::GooglemapApi.new(TOKEN).nearbyplaces(GARBLE, [24.7961217, 120.9966699])
    end).must_raise CodePraise::GooglemapApi::ERROR::ZERO_RESULTS
  end
end
