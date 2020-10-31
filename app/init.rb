# frozen_string_literal: true

folders = %w[controllers models]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
