# frozen_string_literal: false

module DrinkKing
  # Value Module
  module Value
    def self.recommend_drink(sorted_reviews)
      sorted_reviews.map do |sorted_review|
        great_review = sorted_review
        return sorted_review.mention_drink unless sorted_review.mention_drink == 'not mentioned'
        break if sorted_review.rating <= 2
      end
      'no recommend'
    end
  end
end
