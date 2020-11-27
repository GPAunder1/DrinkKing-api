# frozen_string_literal: false

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'
require_relative '../../helpers/database_helper'

describe 'Integration Tests of GoogleMap API and Database' do
  VcrHelper.setup_vcr
  DatabaseHelper.setup_database_cleaner

  before do
    VcrHelper.configure_vcr_for_googlemap
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store places' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'Saving place from GoogleMap to database' do
      places = DrinkKing::Googlemap::ShopMapper.new(TOKEN).find(KEYWORD)
      places.map do |place|
        rebuilt = DrinkKing::Repository::For.entity(place).find_or_create(place)

        _(rebuilt.placeid).must_equal(place.placeid)
        _(rebuilt.name).must_equal(place.name)
        _(rebuilt.address).must_equal(place.address)
        _(rebuilt.latitude).must_equal(place.latitude)
        _(rebuilt.longitude).must_equal(place.longitude)
        _(rebuilt.phone_number).must_equal(place.phone_number)
        _(rebuilt.map_url).must_equal(place.map_url)
        _(rebuilt.opening_now).must_equal(place.opening_now)
        _(rebuilt.rating).must_equal(place.rating)
        _(rebuilt.reviews.count).must_equal(place.reviews.count)

        place.reviews.each do |review|
          found = rebuilt.reviews.find do |potential|
            potential.author == review.author
          end
          _(found.rating).must_equal review.rating
          _(found.relative_time).must_equal review.relative_time
          _(found.content).must_equal review.content
        end
      end
    end
  end
end
