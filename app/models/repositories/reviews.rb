# frozen_string_literal: true

module CodePraise
  module Repository
    # Class for Review
    class Reviews
      def self.all
        Database::ReviewOrm.all.map { |db_review| rebuild_entity(db_review) }
      end

      def self.find_by_shopid(shop_id)
        rebuild_entity Database::ReviewOrm.first(shop_id: shop_id)
      end

      def self.rebuild_entity(db_record)
        return nil unless records

        Entity::Review.new(
          id: db_record.id,
          shop_id: db_record.shop_id,
          author: db_record.author,
          rating: db_record.rating,
          relative_time: db_record.relative_time,
          content: db_record.content
        )
      end

      private_class_method :rebuild_entity, :db_find_or_create
    end
  end
end
