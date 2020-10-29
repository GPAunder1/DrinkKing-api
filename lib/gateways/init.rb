# frozen_string_literal: true

require 'http'

Dir.glob("#{__dir__}/*.rb").each do |file|
  require file
end
