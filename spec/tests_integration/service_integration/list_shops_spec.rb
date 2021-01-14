# frozen_string_literal: true

require_relative '../../helpers/spec_helper.rb'
require_relative '../../helpers/vcr_helper.rb'
require_relative '../../helpers/database_helper.rb'

describe 'ListShops Service Integration Test' do
  VcrHelper.setup_vcr
  DatabaseHelper.setup_database_cleaner

  before do
    VcrHelper.configure_vcr_for_googlemap(recording: :new_episodes)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'List shops to show on map' do
    before do
      DatabaseHelper.wipe_database
    end

    it '(HAPPY) should be able to process shops entirely' do
      # GIVEN: has at least one shop found by search keyword
      shops = DrinkKing::Googlemap::ShopMapper.new(TOKEN).find(KEYWORD, LATITUDE, LONGITUDE)
      db_shop = DrinkKing::Repository::For.entity(shops[0]).find_or_create(shops[0])

      # WHEN: user goes to the shop map page
      result = DrinkKing::Service::ListShops.new.call(search_keyword: KEYWORD)

      # THEN: the result should be success
      _(result.success?).must_equal true
    end

    it '(BAD) should report error if no shop is found' do
      # WHEN: user goes to the shop map page that has no shop found
      shops_made = DrinkKing::Service::ListShops.new.call(search_keyword: GARBLE)

      # THEN: they should get error messege
      _(shops_made.failure.message).must_include 'No shop is found'
    end
  end
end
