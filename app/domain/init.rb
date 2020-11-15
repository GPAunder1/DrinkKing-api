# frozen_string_literal: true

folders = %w[extraction]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
