# frozen_string_literal: true

require_relative '../helpers/spec_helper'
require_relative '../helpers/vcr_helper'
require_relative '../helpers/database_helper'
require 'rack/test'

def app
  DrinkKing::App
end

describe 'Test API routes' do
  include Rack::Test::Methods

  VcrHelper.setup_vcr
  DatabaseHelper.setup_database_cleaner

  before do
    VcrHelper.configure_vcr_for_googlemap
    DatabaseHelper.wipe_database
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Root route' do
    it '(HAPPY) should successfully return root information' do
      get '/'
      _(last_response.status).must_equal 200

      body = JSON.parse(last_response.body)
      _(body['status']).must_equal 'ok'
      _(body['message']).must_include 'api/v1'
    end
  end

  describe 'List shops route' do
    it '(HAPPY) should be able to return shop lists' do
      search_keyword = DrinkKing::Request::SearchKeyword.new(KEYWORD)
      DrinkKing::Service::AddShops.new.call(search_keyword: search_keyword)

      get URI.escape("/api/v1/shops?keyword=#{KEYWORD}")
      _(last_response.status).must_equal 200

      body = JSON.parse(last_response.body)
      shop = body['shops'][2]
      _(shop['placeid']).must_equal SHOPID
      _(shop['name']).must_equal SHOPNAME
      _(shop['reviews'].count).must_equal 5

    end

    it '(HAPPY) should be able to return shop lists that keyword is related both with shopname and drinkname' do
      search_keyword = DrinkKing::Request::SearchKeyword.new(DRINKNAME)
      DrinkKing::Service::AddShops.new.call(search_keyword: search_keyword)

      get URI.escape("/api/v1/shops?keyword=#{DRINKNAME}")
      _(last_response.status).must_equal 200

      body = JSON.parse(last_response.body)
      body['shops'].map do |shop|
        shopname_in_menu = DrinkKing::Service::ShopMenu.new.call(keyword: shop['name']).value!.message[0]['shopname']
        _(shop['name']).must_include shopname_in_menu
      end
    end

    it '(SAD) should report error if no shop is found from database' do
      get "/api/v1/shops?keyword=#{GARBLE}"

      _(last_response.status).must_equal 404
      _(JSON.parse(last_response.body)['status']).must_equal 'not_found'
      _(JSON.parse(last_response.body)['message']).must_include 'No shop is found'
    end
  end

  describe 'Add shops route' do
    it '(HAPPY) should be able to add shops to database' do
      post URI.escape("/api/v1/shops/#{SHOPNAME}")

      _(last_response.status).must_equal 201

      body = JSON.parse(last_response.body)
      shop = body['shops'][2]
      _(shop['placeid']).must_equal SHOPID
      _(shop['name']).must_equal SHOPNAME
      _(shop['reviews'].count).must_equal 5
    end

    it '(BAD) should fail for invalid search keyword' do
      post "/api/v1/shops/#{GARBLE}"

      _(last_response.status).must_equal 400
      _(JSON.parse(last_response.body)['status']).must_equal 'bad_request'
      _(JSON.parse(last_response.body)['message']).must_equal 'Please enter keyword related to drink'
    end

    it '(SAD) should fail if no shop is found from menu with a searchkeyword' do
      post '/api/v1/shops/sdffsdfds'

      _(last_response.status).must_equal 404
      _(JSON.parse(last_response.body)['status']).must_equal 'not_found'
      _(JSON.parse(last_response.body)['message']).must_include 'No shop is found from menu'
    end

    it '(SAD) should fail if no shop is found from menu with a googlemapAPI' do
      post URI.escape('/api/v1/shops/川越茶飲')

      _(last_response.status).must_equal 404
      _(JSON.parse(last_response.body)['status']).must_equal 'not_found'
      _(JSON.parse(last_response.body)['message']).must_include 'Error with Gmap API:'
    end
  end

  describe 'Extract shop route' do
    it 'should be able to extract shop' do
      search_keyword = DrinkKing::Request::SearchKeyword.new(KEYWORD)
      DrinkKing::Service::AddShops.new.call(search_keyword: search_keyword)

      get "/api/v1/extractions/#{SHOPID}"
      _(last_response.status).must_equal 202

      30.times { sleep(1) and print('.') }

      get "/api/v1/extractions/#{SHOPID}"
      _(last_response.status).must_equal 200
      body = JSON.parse(last_response.body)
      _(body['message']).must_include RECOMMEND_DRINK
    end
  end

  describe 'Get shop menu' do
    it 'should be able to get shop menu by specific drink' do
      get URI.escape("api/v1/menus?keyword=#{DRINKNAME}&searchby=drink")
      _(last_response.status).must_equal 200
      body = JSON.parse(last_response.body)

      _(body[0]['drinks'].select { |drink| drink['name'].include?(DRINKNAME) }.empty?).must_equal false
    end

    it 'should be able to get shop menu by shopname' do
      get URI.escape("api/v1/menus?keyword=#{SHOPNAME}&searchby=shop")
      _(last_response.status).must_equal 200
      body = JSON.parse(last_response.body)
      body.map do |shop|
        _(shop['shopname']).must_equal SHOPNAME
      end
    end
  end
end
