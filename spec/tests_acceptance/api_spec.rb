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

  # VcrHelper.setup_vcr
  # DatabaseHelper.setup_database_cleaner
  #
  # before do
  #   VcrHelper.configure_vcr_for_googlemap
  #   DatabaseHelper.wipe_database
  # end
  #
  # after do
  #   VcrHelper.eject_vcr
  # end

  describe 'Root route' do
    it 'should successfully return root information' do
      get '/'
      _(last_response.status).must_equal 200

      body = JSON.parse(last_response.body)
      _(body['status']).must_equal 'ok'
      _(body['message']).must_include 'api/v1'
    end
  end

  # 我之後再寫
  describe 'List shops route' do
    it 'should be able to return shop lists' do
      skip
      get "/api/v1/shops?keyword=#{KEYWORD}"
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
      get "/api/v1/extractions/#{SHOPID}"
      _(last_response.status).must_equal 200
      body = JSON.parse(last_response.body)
      _(body).must_equal RECOMMEND_DRINK
    end
  end

  describe 'Get shop menu' do
    it 'should be able to get shop menu by specific drink' do
      get URI.escape("api/v1/menus?keyword=#{DRINKNAME}&searchby=drink")
      _(last_response.status).must_equal 200
      body = JSON.parse(last_response.body)
      body.map do |shop|
        shop['drinks'].map { |drink| _(drink).must_include DRINKNAME }
      end
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
