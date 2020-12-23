# frozen_string_literal: false
# coding:utf8

require 'jieba_rb'
require 'net/http'

module DrinkKing
  module Mapper
    # Class for ReviewExtractionMapper
    class ReviewExtractionMapper
      SERVER_URL = 'https://soa-nlp-api.herokuapp.com'.freeze
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
        uri = URI(SERVER_URL + '/tokenize'.to_s)
        res = Net::HTTP.post_form(uri, 'sentence' => sentence)
        words = res.body.force_encoding(Encoding::UTF_8)
        JSON.parse(words)
      end

      private_class_method :rebuild_entity, :tokenize
    end
  end
end
