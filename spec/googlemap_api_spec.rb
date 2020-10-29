# frozen_string_literal: true

require_relative 'spec_helper'

describe 'Testing GooglemapApi Library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock

    c.filter_sensitive_data('<GOOGLEMAP_TOKEN>') { TOKEN }
    c.filter_sensitive_data('<GOOGLEMAP_TOKEN_ESC>') { CGI.escape(TOKEN) }
  end

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'Place information' do
    it 'checking the shop name' do
      places = CodePraise::Googlemap::ShopMapper.new(TOKEN).find(KEYWORD)
      _(places.size).must_equal CORRECT.size
    end

    it 'checking bad token' do
      _(CodePraise::Googlemap::ShopMapper.new(BAD_TOKEN).find(KEYWORD))
        .must_equal 'The provided API key is invalid.'
    end

    it 'checking attritube of each shop' do
      places = CodePraise::Googlemap::ShopMapper.new(TOKEN).find(KEYWORD)
      places.map do |place|
        assert(%i[name address location opening_now rating].all? { |s| place.to_h.key? s })
      end
    end

    it 'checking no result' do
      _(CodePraise::Googlemap::ShopMapper.new(TOKEN).find(GARBLE)).must_equal 'No result.'
    end
  end
end
