# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'

describe 'Testing GooglemapApi Library' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_googlemap
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Place information' do
    it 'checking the shop name' do
      places = DrinkKing::Googlemap::ShopMapper.new(TOKEN).find(KEYWORD, LATITUDE, LONGITUDE)
      _(places.size).must_be :>, 0
    end

    it 'checking bad token' do
      _(DrinkKing::Googlemap::ShopMapper.new(BAD_TOKEN).find(KEYWORD, LATITUDE, LONGITUDE))
        .must_equal 'The provided API key is invalid.'
    end

    it 'checking attritube of each shop' do
      places = DrinkKing::Googlemap::ShopMapper.new(TOKEN).find(KEYWORD, LATITUDE, LONGITUDE)
      places.map do |place|
        assert(%i[name address opening_now rating].all? { |s| place.to_h.key? s })
      end
    end

    it 'checking no result' do
      _(DrinkKing::Googlemap::ShopMapper.new(TOKEN).find(GARBLE, LATITUDE, LONGITUDE)).must_equal 'No result.'
    end
  end
end
