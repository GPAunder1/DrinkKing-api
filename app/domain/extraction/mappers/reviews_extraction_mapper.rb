# frozen_string_literal: false

module CodePraise
  module Mapper
    # Class for ReviewsExtractionMapper
    class ReviewsExtractionMapper
      def self.find_by_shopid(shop_id)
        shop_entity = CodePraise::Repository::Shops.find_id(shop_id)
        rebuild_entity(shop_entity)
      end

      def self.rebuild_entity(shop_entity)
        CodePraise::Entity::ReviewsExtraction.new(
          name: shop_entity.name,
          reviews: CodePraise::Mapper::ReviewExtractionMapper.rebuild_many(shop_entity.reviews)
        )
      end
      private_class_method :rebuild_entity
    end
  end
end
