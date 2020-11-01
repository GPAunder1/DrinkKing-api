# frozen_string_literal: true

# require 'pry'

%w[app config]
  .each do |folder|
    require_relative "#{folder}/init"
  end
