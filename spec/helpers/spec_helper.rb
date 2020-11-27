# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require 'vcr'
require 'webmock'
require_relative '../../init'

GARBLE = 'dcnisndisncsdc'
BAD_TOKEN = 'snidnsicndsivndsivdsv'
KEYWORD = '可不可熟成紅茶'
TOKEN = DrinkKing::App.config.API_TOKEN
CORRECT = YAML.load(File.read('spec/fixtures/googlemap_results.yml'))

# Helper methods
def indexpage
  DrinkKing::App.config.APP_HOST
end
