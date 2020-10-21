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
      places = CodePraise::GooglemapApi.new(TOKEN).nearbyplaces('飲料', [24.7961217, 120.9966699])
      _(places.size).must_equal CORRECT.size
    end

    it 'checking bad token' do
      _(CodePraise::GooglemapApi.new(BAD_TOKEN).nearbyplaces('飲料', [24.7961217, 120.9966699]))
        .must_equal 'The provided API key is invalid.'
    end

    it 'checking no result' do
      _(CodePraise::GooglemapApi.new(TOKEN).nearbyplaces(GARBLE, [24.7961217, 120.9966699])).must_equal 'No result.'
    end

    it 'checking input error' do
      _(CodePraise::GooglemapApi.new(TOKEN).nearbyplaces(GARBLE, 120.9966699)).must_equal 'Location must be an array.'
    end
  end
end
