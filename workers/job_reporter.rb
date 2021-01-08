# frozen_string_literal: true

require_relative 'progress_publisher'

module RecommendDrink
  class JobReporter
    attr_accessor :shop_id, :id
    def initialize(request_json, config)
      extraction_request = DrinkKing::Representer::ExtractionRequest
                           .new(OpenStruct.new)
                           .from_json(request_json)
      @publisher = ProgressPublisher.new(config, extraction_request.id)
      @shop_id = extraction_request.shop_id
      @id = extraction_request.id
    end

    def report(msg)
      @publisher.publish msg
    end

    def report_each_second(seconds, &operation)
      seconds.times do
        sleep(1)
        report(operation.call)
      end
    end
  end
end
