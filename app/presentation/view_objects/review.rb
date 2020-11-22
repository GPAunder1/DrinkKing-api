# frozen_string_literal: true

module Views
  # View for review of a shop
  class Review
    def initialize(review)
      @review = review
    end

    def author
      @review.author
    end

    def rating
      @review.rating
    end

    def relative_time
      @review.relative_time
    end

    def content
      @review.content
    end

  end
end
