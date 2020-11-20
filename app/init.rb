# frozen_string_literal: true

folders = %w[controllers models infrastructure domain presentation]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
