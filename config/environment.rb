# frozen_string_literal: true

require 'econfig'
require 'roda'
require 'yaml'
require 'json'
require 'delegate'

module DrinkKing
  # Configuration for the App
  class App < Roda
    plugin :environments # plugin for ENV['RACK_ENV']
    extend Econfig::Shortcut
    Econfig.env = environment.to_s
    Econfig.root = '.'

    use Rack::Session::Cookie, secret: config.SESSION_SECRET

    configure :development, :test do
      ENV['DATABASE_URL'] = "sqlite://#{config.DB_FILENAME}"
    end
    configure :production do
      # Set DATABASE_URL env var on production platform
    end

    configure do
      require 'sequel'
      DB = Sequel.connect(ENV['DATABASE_URL']) # rubocop:disable Lint/ConstantDefinitionInBlock

      def self.DB # rubocop:disable Naming/MethodName
        DB
      end
    end
    # CONFIG = YAML.safe_load(File.read('./config/secrets.yml'))
    # TOKEN = CONFIG['API_TOKEN']
  end
end
