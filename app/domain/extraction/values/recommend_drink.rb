# frozen_string_literal: false

module CodePraise
  # Value Module
  module Value
    def self.recommend_drink(sorted_review)
      loop do
        great_review = sorted_review.pop
        return great_review.mention_drink unless great_review.mention_drink == '沒推薦'
        break if great_review.rating == 2
      end
      '沒推薦'
    end
  end
end
