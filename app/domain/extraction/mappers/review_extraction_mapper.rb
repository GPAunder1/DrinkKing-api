# frozen_string_literal: false

require 'ckip_client'

module CodePraise
  module Mapper
    # Class for ReviewExtractionMapper
    class ReviewExtractionMapper

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::ReviewExtraction.new(
          id: db_record.id,
          author: db_record.author,
          rating: db_record.rating,
          relative_time: db_record.relative_time,
          content: db_record.content,
          characters: tokenize(db_record.content)
        )
      end

      def tokenize(sentence)
        CKIP.segment(sentence)
      end

      private_class_method :rebuild_entity
    end
  end
end
