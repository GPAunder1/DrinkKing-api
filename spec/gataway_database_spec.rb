# frozen_string_literal: false

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'
require_relative 'helpers/database_helper'

describe 'Integration Tests of GoogleMap API and Database' do
  VcrHelper.setup_vcr
  DatabaseHelper.setup_database_cleaner

  before do
    VcrHelper.configure_vcr_for_github
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store places' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'Saving place from GoogleMap to database' do
      places = CodePraise::GoogleMap::ShopMapper.new(TOKEN).find(KEYWORD)

      rebuilt = CodePraise::Repository::For.entity(places).create(places)

      _(rebuilt.placeid).must_equal(places.placeid)
      _(rebuilt.name).must_equal(places.name)
      _(rebuilt.address).must_equal(places.address)
      _(rebuilt.phone_number).must_equal(places.phone_number)
      _(rebuilt.map_url).must_equal(places.map_url)
      _(rebuilt.opening_now).must_equal(places.opening_now)
      _(rebuilt.rating).must_equal(places.rating)
      _(rebuilt.reviews.count).must_equal(places.reviews.count)

      places.reviews.each do |review|
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
