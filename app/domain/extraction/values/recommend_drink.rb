# frozen_string_literal: false

module DrinkKing
  # Value Module
  module Value
    def self.recommend_drink(sorted_reviews)
      sorted_reviews.map do |sorted_review|
        mention_drink_in_review = sorted_review.mention_drink
        return mention_drink_in_review unless mention_drink_in_review == 'not mentioned'
        break if sorted_review.rating <= 2
      end
      'no recommend'
    end
  end
end
