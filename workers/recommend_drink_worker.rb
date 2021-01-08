# frozen_string_literal: true

require_relative '../init'

require 'econfig'
require 'shoryuken'
require_relative 'recommend_drink_monitor'
require_relative 'job_reporter'

# RecommendDrinkWorker
module RecommendDrink
  class Worker
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
      puts "hiii#{request}"
      job = JobReporter.new(request, Worker.config)
      puts "#{job.shop_id}=======#{job.id}"
      DrinkKing::Mapper::ReviewsExtractionMapper.find_by_shopid(job.shop_id).find_recommend_drink
      # Keep sending finished status to any latecoming subscribers
      job.report_each_second(2) { RecommendDrink::RecommendDrinkMonitor.finished_percent }
    rescue StandardError => error
      puts "#{error}"
      puts 'No shop has to be extracted at this moment'
    end
  end
end
