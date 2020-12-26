# frozen_string_literal: true

module RecommendDrink
  module RecommendDrinkMonitor
    RECOMMEND_DRINK_PROGRESS = {
      'STARTED' => 15,
      'Calculating' => 30,
      'remote' => 70,
      'Receiving' => 85,
      'Resolving' => 95,
      'Checking' => 100,
      'FINISHED' => 100
    }.freeze

    def self.starting_percent
      RECOMMEND_DRINK_PROGRESS['STARTED'].to_s
    end

    def self.finished_percent
      RECOMMEND_DRINK_PROGRESS['FINISHED'].to_s
    end

    def self.percent(stage)
      RECOMMEND_DRINK_PROGRESS[stage].to_s
    end
  end
end
