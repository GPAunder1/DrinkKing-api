# frozen_string_literal: false
# coding:utf8

require 'jieba_rb'

module CodePraise
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
        seg = JiebaRb::Segment.new
        seg.cut(sentence).uniq
        # uri = URI('http://jedi.nlplab.cc:8000/api/jieba/')
        # res = Net::HTTP.post_form(uri, 'sentence' => sentence)
        # res = res.body.force_encoding('GBK')
        # res = res.encode('UTF-8')
        # .split(" ").uniq
      end

      private_class_method :rebuild_entity, :tokenize
    end
  end
end
