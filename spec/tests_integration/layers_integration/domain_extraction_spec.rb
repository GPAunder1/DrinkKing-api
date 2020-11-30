# frozen_string_literal: false

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'
require_relative '../../helpers/database_helper'

describe 'Domain extraction by Tim' do
  VcrHelper.setup_vcr
  DatabaseHelper.setup_database_cleaner

  before do
    VcrHelper.configure_vcr_for_googlemap(recording: :new_episodes)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Creating domain_reviews_entity' do
    before do
      # add shop into database before reviewsextraction
      places = DrinkKing::Googlemap::ShopMapper.new(TOKEN).find(KEYWORD)
      places.map do |place|
        DrinkKing::Repository::For.entity(place).find_or_create(place)
      end
    end

    it 'create_reviews_extraction_entity' do
      from_database = DrinkKing::Repository::Shops.find_shop(KEYWORD).first
      rebuilt = DrinkKing::Mapper::ReviewsExtractionMapper.find_by_shopname(KEYWORD)
      _(rebuilt.name).must_equal(from_database.name)
      _(rebuilt.reviews.count).must_equal(from_database.reviews.count)
      # puts rebuilt.reviews.count
      rebuilt.reviews.each do |review|
        assert(review.tokens)
      end
    end

    it 'should get recommend drink' do
      rebuilt = DrinkKing::Mapper::ReviewsExtractionMapper.find_by_shopname(KEYWORD)
      # puts rebuilt.recommend_drink
      refute_empty rebuilt.recommend_drink
    end
  end
end
