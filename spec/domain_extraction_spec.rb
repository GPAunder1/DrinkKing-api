# frozen_string_literal: false

require_relative 'helpers/spec_helper'
require_relative 'helpers/vcr_helper'
require_relative 'helpers/database_helper'
require 'jieba_rb'
require 'net/http'

describe 'Development_test_by_Tim' do
  VcrHelper.setup_vcr
  DatabaseHelper.setup_database_cleaner

  before do
    VcrHelper.configure_vcr_for_googlemap
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Creating domain_reviews_entity' do
    rebuilt = CodePraise::Mapper::ReviewsExtractionMapper.find_by_shopname('可不可')
    it 'create_reviews_extraction_entity' do
      from_database = CodePraise::Repository::Shops.find_shop('可不可').first
      _(rebuilt.name).must_equal(from_database.name)
      _(rebuilt.reviews.count).must_equal(from_database.reviews.count)
      rebuilt.reviews.each do |review|
        assert(review.tokens)
      end
    end

    it 'Testing value function' do
      put rebuilt.recommend_drink
      refute_empty rebuilt.recommend_drink
    end
  end
end
