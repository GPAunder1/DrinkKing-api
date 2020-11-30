# frozen_string_literal: true

require_relative '../../helpers/spec_helper.rb'
require_relative '../../helpers/vcr_helper.rb'
require_relative '../../helpers/database_helper.rb'

describe 'AddShops Service Integration Test' do
  VcrHelper.setup_vcr
  DatabaseHelper.setup_database_cleaner

  before do
    VcrHelper.configure_vcr_for_googlemap(recording: :new_episodes)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Search and store and retrieve shops' do
    before do
      DatabaseHelper.wipe_database
    end

    it '(HAPPY) should be able to find and save shops to database' do
      # GIVEN: a valid search keyword to find shops
      shops = DrinkKing::Googlemap::ShopMapper.new(TOKEN).find(KEYWORD)
      keyword_request = DrinkKing::Forms::SearchKeyword.new.call(search_keyword: KEYWORD)

      # WHEN: the service is called with the request form object
      shops_made = DrinkKing::Service::AddShops.new.call(keyword_request)

      # THEN: the result should be success
      _(shops_made.success?).must_equal true
      # THEN: and should provide shop entity same as the entity get from API response
      rebuilt = shops_made.value!

      shops.map.with_index do |shop, i|
        _(rebuilt[i].placeid).must_equal(shop.placeid)
        _(rebuilt[i].name).must_equal(shop.name)
        _(rebuilt[i].address).must_equal(shop.address)
        _(rebuilt[i].latitude).must_equal(shop.latitude)
        _(rebuilt[i].longitude).must_equal(shop.longitude)
        _(rebuilt[i].map_url).must_equal(shop.map_url)
        _(rebuilt[i].rating).must_equal(shop.rating)
        _(rebuilt[i].reviews.count).must_equal(shop.reviews.count)

        shop.reviews.each do |review|
          found = rebuilt[i].reviews.find do |potential|
            potential.author == review.author
          end
          _(found.rating).must_equal review.rating
          _(found.relative_time).must_equal review.relative_time
          _(found.content).must_equal review.content
        end
      end
    end

    it '(HAPPY) should be able to find and return existing shops in database' do
      # GIVEN: a valid search keyword to find shops and the shop are already in database
      keyword_request = DrinkKing::Forms::SearchKeyword.new.call(search_keyword: KEYWORD)
      db_shops = DrinkKing::Service::AddShops.new.call(keyword_request).value!

      # WHEN: the service is called with the request form object
      shops_made = DrinkKing::Service::AddShops.new.call(keyword_request)

      # THEN: the result should be success
      _(shops_made.success?).must_equal true

      # THEN: and find the same object from database
      rebuilt = shops_made.value!
      db_shops.map.with_index do |shop, i|
        _(rebuilt[i].placeid).must_equal(shop.placeid)
        _(rebuilt[i].name).must_equal(shop.name)
        _(rebuilt[i].address).must_equal(shop.address)
        _(rebuilt[i].latitude).must_equal(shop.latitude)
        _(rebuilt[i].longitude).must_equal(shop.longitude)
        _(rebuilt[i].map_url).must_equal(shop.map_url)
        _(rebuilt[i].rating).must_equal(shop.rating)
        _(rebuilt[i].reviews.count).must_equal(shop.reviews.count)

        shop.reviews.each do |review|
          found = rebuilt[i].reviews.find do |potential|
            potential.author == review.author
          end
          _(found.rating).must_equal review.rating
          _(found.relative_time).must_equal review.relative_time
          _(found.content).must_equal review.content
        end
      end
    end

    it '(BAD) should fail for invalid search keyword' do
      # GIVEN: a valid search keyword to find shops
      keyword_request = DrinkKing::Forms::SearchKeyword.new.call(search_keyword: GARBLE)

      # WHEN: the service is called with the request form object
      shops_made = DrinkKing::Service::AddShops.new.call(keyword_request)

      # THEN: the result should be failure and get error message
      _(shops_made.success?).must_equal false
      _(shops_made.failure).must_equal 'Please enter keyword related to drink'
    end
  end
end
