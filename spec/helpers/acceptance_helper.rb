# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'headless'
require 'watir'
require 'page-object'

require_relative 'spec_helper.rb'
require_relative 'database_helper.rb'

MARKER_URL = 'https://www.flaticon.com/svg/static/icons/svg/3106/3106180.svg'
