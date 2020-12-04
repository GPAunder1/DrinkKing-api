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
    it 'should successfully return root information' do
      get '/'
      _(last_response.status).must_equal 200

      body = JSON.parse(last_response.body)
      _(body['status']).must_equal 'ok'
      _(body['message']).must_include 'api/v1'
    end
  end

  describe 'List shops route' do
    it 'should be able to return shop lists' do
      search_keyword = DrinkKing::Request::SearchKeyword.new(KEYWORD)
      DrinkKing::Service::AddShops.new.call(search_keyword: search_keyword)

      get URI.escape("/api/v1/shops?keyword=#{KEYWORD}")
      _(last_response.status).must_equal 200

      body = JSON.parse(last_response.body)
      shop = body['shops'][0]
      _(shop['placeid']).must_equal SHOPID
      _(shop['name']).must_equal SHOPNAME
      _(shop['reviews'].count).must_equal 5
      _(shop['menu']['shopname']).must_include SHOPNAME
    end
  end

  describe 'Add shops route' do
    it 'should be able to add shops to database' do
      post URI.escape("/api/v1/shops/#{SHOPNAME}")
      _(last_response.status).must_equal 201

      body = JSON.parse(last_response.body)
      shop = body['shops'][0]
      _(shop['placeid']).must_equal SHOPID
      _(shop['name']).must_equal SHOPNAME
      _(shop['reviews'].count).must_equal 5
    end
  end

  # 交給你了
  describe 'Extract shop route' do
    it 'should be able to extract shop' do
      skip
      get "/api/v1/extractions/#{SHOPID}"
    end
  end

  # 交給你了
  describe 'Get shop menu' do
    it 'should be able to get shop menu by specific drink' do
      skip
      get "api/v1/menus?keyword=#{DRINKNAME}&searchby=drink"
    end

    it 'should be able to get shop menu by shopname' do
      skip
      get "api/v1/menus?keyword=#{SHOPNAME}&searchby=shop"
    end

  end
end
