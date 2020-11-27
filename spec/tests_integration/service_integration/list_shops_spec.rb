# frozen_string_literal: true

require_relative '../../helpers/spec_helper.rb'
require_relative '../../helpers/vcr_helper.rb'
require_relative '../../helpers/database_helper.rb'

describe 'ListShops Service Integration Test' do
  VcrHelper.setup_vcr
  DatabaseHelper.setup_database_cleaner

  before do
    VcrHelper.configure_vcr_for_googlemap(recording: :none)
    DatabaseHelper.wipe_database
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'List Shops' do
    it '(HAPPY) should get shops that had been searched before' do
      # GIVEN: shops exist locally and has been searched
      shops = DrinkKing::Googlemap::ShopMapper.new(TOKEN).find(KEYWORD)
      db_shop = DrinkKing::Repository::For.entity(shops[0]).find_or_create(shops[0])

      search_record = ["#{KEYWORD}"]

      # WHEN: we request to list shops
      result = DrinkKing::Service::ListShops.new.call(search_record)

      # THEN: we should see shop list
      _(result.success?).must_equal true
      shops = result.value!
      _(shops).must_include db_shop
    end

    it '(SAD) shoud not see shops if they are not in database' do
      # GIVEN: we have searched keyword that results no shop
      search_record = ["#{KEYWORD}"]

      # WHEN: we request to list shops
      result = DrinkKing::Service::ListShops.new.call(search_record)

      # THEN: it should return empty
      _(result.success?).must_equal true
      shops = result.value!
      _(shops).must_equal []
    end

  end
end
