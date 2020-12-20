# frozen_string_literal: false

module DrinkKing
  module Entity
    # class for ReviewsExtraction
    class ReviewsExtraction < Dry::Struct
      include Dry.Types
      attribute :id, Strict::Integer
      attribute :name, Strict::String
      attribute :reviews, Strict::Array.of(ReviewExtraction)

      def popular_review
        reviews.reduce do |review1, review2|
          review1.rating > review2.rating ? review1 : review2
        end
      end

      def find_recommend_drink
        sorted_reviews = reviews.sort_by {|review| review.rating}.reverse
        recommend_drink = Value.recommend_drink(sorted_reviews)
        add_to_database(recommend_drink)

        recommend_drink
      end

      def sortedby_rating
        reviews.sort_by! { |review| review.rating }
      end

      def add_to_database(recommend_drink)
        Database::ShopOrm.first(id: id).update(recommend_drink: recommend_drink)
      end
      # private_class_method :sortedby_rating
    end
  end
end
