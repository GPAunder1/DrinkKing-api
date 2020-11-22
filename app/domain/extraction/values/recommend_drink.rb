# frozen_string_literal: false

module DrinkKing
  # Value Module
  module Value
    def self.recommend_drink(sorted_review)
      loop do
        great_review = sorted_review.pop
        return great_review.mention_drink unless great_review.mention_drink == 'not mentioned'
        break if great_review.rating <= 2
      end
      'no recommend'
    end
  end
end
