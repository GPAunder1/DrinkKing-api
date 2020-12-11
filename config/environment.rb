# frozen_string_literal: true

require 'econfig'
require 'roda'
require 'yaml'
require 'json'
require 'delegate'
require 'rack/cache'
require 'redis-rack-cache'

module DrinkKing
  # Configuration for the App
  class App < Roda
    plugin :environments # plugin for ENV['RACK_ENV']
    extend Econfig::Shortcut
    Econfig.env = environment.to_s
    Econfig.root = '.'

    configure :development, :test do
      ENV['DATABASE_URL'] = "sqlite://#{config.DB_FILENAME}"
    end

    configure :development do
      use Rack::Cache,
          verbose: true,
          metastore: 'file:_cache/rack/meta',
          entitystore: 'file:_cache/rack/body'
    end

    configure :production do
      # Set DATABASE_URL env var on production platform
      use Rack::Cache,
          verbose: true,
          metastore: config.REDISCLOUD_URL + '/0/metastore',
          entitystore: config.REDISCLOUD_URL + '/0/entitystore'
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
