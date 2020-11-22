# frozen_string_literal: true

folders = %w[shops extraction]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
