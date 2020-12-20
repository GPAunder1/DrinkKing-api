# frozen_string_literal: true

require_relative '../init'

require 'econfig'
require 'shoryuken'

# RecommendDrinkWorker
class RecommendDrinkWorker
  extend Econfig::Shortcut
  Econfig.env = ENV['RACK_ENV'] || 'development'
  Econfig.root = File.expand_path('..', File.dirname(__FILE__))
  Shoryuken.sqs_client = Aws::SQS::Client.new(
    access_key_id: config.AWS_ACCESS_KEY_ID,
    secret_access_key: config.AWS_SECRET_ACCESS_KEY,
    region: config.AWS_REGION
  )
  include Shoryuken::Worker
  shoryuken_options queue: config.EXTRACT_QUEUE_URL, auto_delete: true
  def perform(_sqs_msg, request)
    DrinkKing::Mapper::ReviewsExtractionMapper.find_by_shopid(request).find_recommend_drink
  end
end
