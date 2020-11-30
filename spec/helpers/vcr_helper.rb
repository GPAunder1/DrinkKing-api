# frozen_string_literal: true

require 'vcr'
require 'webmock'

# Setting up VCR
class VcrHelper
  CASSETTES_FOLDER = 'spec/fixtures/cassettes'
  CASSETTE_FILE = 'googlemap_api'

  def self.setup_vcr
    VCR.configure do |c|
      c.cassette_library_dir = CASSETTES_FOLDER
      c.hook_into :webmock

      c.filter_sensitive_data('<GOOGLEMAP_TOKEN>') { TOKEN }
      c.filter_sensitive_data('<GOOGLEMAP_TOKEN_ESC>') { CGI.escape(TOKEN) }
    end
  end

  def self.configure_vcr_for_googlemap(recording: :new_episodes)
    VCR.insert_cassette(
      CASSETTE_FILE,
      record: recording,
      match_requests_on: %i[method uri headers]
    )
  end

  def self.eject_vcr
    VCR.eject_cassette
  end
end
