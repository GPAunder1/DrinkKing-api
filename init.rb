# frozen_string_literal: true

# require 'pry'

%w[config app]
  .each do |folder|
    require_relative "#{folder}/init"
  end
