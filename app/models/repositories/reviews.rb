# frozen_string_literal: true

module CodePraise
  module Repository
    # Class for Review
    class Reviews
      def self.find_id(id)
        rebuild_entity Database::ReviewOrm.first(id: id)
      end

      def self.find_by_shopid(shop_id)
        rebuild_entity Database::ReviewOrm.first(shop_id: shop_id)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Review.new(
          id: db_record.id,
          author: db_record.author,
          rating: db_record.rating,
          relative_time: db_record.relative_time,
          content: db_record.content
        )
      end

      def self.rebuild_many(db_record)
        db_record.map { |db_review| Reviews.rebuild_entity(db_review) }
      end

      def self.db_find_or_create(entity)
        Database::ReviewOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
