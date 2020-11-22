# frozen_string_literal: true

require_relative 'parser'

module DrinkKing
  module Googlemap
    # Data Mapper: Googlemap placedetails -> Shop and Review entity
    class ShopDetailMapper
      def initialize(token, gateway_class = Googlemap::Api)
        @token = token
        @gateway = gateway_class.new(@token)
      end

      def find_by_placeid(placeid)
        data = @gateway.placedetails_data(placeid)
        Parsers::ApiResponse.new(data).apierror? ? data : raise_error(data)
      end

      def self.build_review_entity(reviews)
        reviews.map { |review| DataMapperReview.new(review).build_entity }
      end

      def raise_error(error_string)
        error_string
      end
    end

    # Extracts entity specific elements from data structure
    class DataMapperReview
      def initialize(data)
        @data = data
      end

      def build_entity
        DrinkKing::Entity::Review.new(
          id: nil,
          author: author,
          rating: rating,
          relative_time: relative_time,
          content: content
        )
      end

      private

      def author
        @data['author_name'] ||= nil
      end

      def rating
        @data['rating'] ||= nil
      end

      def relative_time
        @data['relative_time_description'] ||= nil
      end

      def content
        @data['text'] ||= nil
      end
    end
  end
end
