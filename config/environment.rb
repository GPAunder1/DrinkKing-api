# frozen_string_literal: true

require 'econfig'
require 'roda'
require 'yaml'

module CodePraise
  # Configuration for the App
  class App < Roda
    plugin :environments # plugin for ENV['RACK_ENV']
    extend Econfig::Shortcut
    Econfig.env = environment.to_s
    Econfig.root = '.'

    configure :development, :test do
      ENV['DATABASE_URL'] = "sqlite://#{config.DB_FILENAME}"
    end
    configure :production do
      # Set DATABASE_URL env var on production platform
    end

    configure do
      require 'sequel'
      DB = Sequel.connect(ENV['DATABASE_URL'])

      def self.DB
        DB
      end
    end
    # CONFIG = YAML.safe_load(File.read('./config/secrets.yml'))
    # TOKEN = CONFIG['api_token']
  end
end
