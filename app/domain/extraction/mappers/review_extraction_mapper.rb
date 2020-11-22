# frozen_string_literal: false
# coding:utf8

require 'jieba_rb'
require 'net/http'

module DrinkKing
  module Mapper
    # Class for ReviewExtractionMapper
    class ReviewExtractionMapper
      def self.rebuild_many(reviews)
        reviews.map { |review| rebuild_entity(review) }
      end

      def self.rebuild_entity(review)
        return nil unless review

        Entity::ReviewExtraction.new(
          id: review.id,
          author: review.author,
          rating: review.rating,
          relative_time: review.relative_time,
          content: review.content,
          tokens: tokenize(review.content)
        )
      end

      def self.tokenize(sentence)
        # seg = JiebaRb::Segment.new
        # seg.cut(sentence).uniq
        uri = URI('https://soa-nlp-api.herokuapp.com/tokenize')
        res = Net::HTTP.post_form(uri, 'sentence' => sentence)
        res.body.force_encoding(Encoding::UTF_8).split(" ")
      end

      private_class_method :rebuild_entity, :tokenize
    end
  end
end
