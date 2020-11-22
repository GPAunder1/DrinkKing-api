# frozen_string_literal: true

require_relative 'helpers/spec_helper'
require_relative 'helpers/database_helper'
require_relative 'helpers/vcr_helper'
require 'headless'
require 'watir'

describe 'Acceptance Tests' do
  DatabaseHelper.setup_database_cleaner

  before do
    DatabaseHelper.wipe_database
    # @headless = Headless.new
    @browser = Watir::Browser.new
  end

  after do
    @browser.close
    # @headless.destroy
  end

  describe 'HomePage' do
    describe 'Visit index page' do
      it '(HAPPY) should not see any shop before search' do
        # GIVEN: user is on the index page without any search
        @browser.goto homepage
        # THEN: user should see header and search box and empty table
        _(@browser.h1(id: 'main_header').text).must_equal 'DrinkKing'
      end
    end

    describe 'Search keyword' do
      it '(HAPPY) should be able to search' do
        # GIVEN: user is on the index page
        @browser.goto homepage
        # WHEN: user search a keyword
        @browser.text_field(id: 'drinking_shop_input').set(KEYWORD)
        @browser.button(id: 'repo-form-submit').click
        # THEN: user to see shop's page
        @browser.url.include? KEYWORD
      end

      it '(BAD) should not be able to search invalid keyword' do
        # GIVEN: user is on the index page
        @browser.goto homepage
        # WHEN: user search invalid keyword
        @browser.text_field(id: 'drinking_shop_input').set(GARBLE)
        @browser.button(id: 'repo-form-submit').click
        # THEN: user should see a error message
        _(@browser.div(id: 'flash_bar_danger').present?).must_equal true
        _(@browser.div(id: 'flash_bar_danger').text).must_equal 'Please enter keyword related to drink'
      end
    end
  end

  describe 'Shop Page' do
    it '(HAPPY) should see shop place on map if found shop' do
      places = DrinkKing::Googlemap::ShopMapper.new(TOKEN).find(KEYWORD)
      DrinkKing::Repository::For.entity(places[0]).find_or_create(places[0])

      # GIVEN: user is on the shop page
      @browser.goto "http://localhost:9000/shop/#{KEYWORD}"
      # THEN: they should see shop map
      _(@browser.div(id: 'map').present?).must_equal true
      _(@browser.div(id: 'list').present?).must_equal false
    end

    it '(HAPPY) should be able to switch between shop map and shop list' do
      places = DrinkKing::Googlemap::ShopMapper.new(TOKEN).find(KEYWORD)
      DrinkKing::Repository::For.entity(places[0]).find_or_create(places[0])

      # GIVEN: user is on the shop page
      @browser.goto "http://localhost:9000/shop/#{KEYWORD}"
      # WHEN: user click on list button
      @browser.button(id: 'listbtn').click
      # THEN: they shoud see shop list
      _(@browser.div(id: 'map').present?).must_equal false
      _(@browser.div(id: 'list').present?).must_equal true
    end

    it '(BAD) should report error if no shop is found' do
      # GIVEN: user is on the shop page that doesn't have shop
      @browser.goto "http://localhost:9000/shop/#{GARBLE}"

      # THEN: they should see error message
      _(@browser.div(id: 'flash_bar_danger').present?).must_equal true
      _(@browser.div(id: 'flash_bar_danger').text).must_equal 'No shop is found!'
    end

  end
end
