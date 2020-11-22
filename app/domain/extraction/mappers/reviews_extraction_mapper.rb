# frozen_string_literal: false

module DrinkKing
  module Mapper
    # Class for ReviewsExtractionMapper
    class ReviewsExtractionMapper
      def self.find_by_shopid(shop_id)
        shop_entity = DrinkKing::Repository::Shops.find_id(shop_id)
        rebuild_entity(shop_entity)
      end

      # Only Show one record
      def self.find_by_shopname(shopname)
        shop_entity = DrinkKing::Repository::Shops.find_shop(shopname).first
        rebuild_entity(shop_entity)
      end

      def self.rebuild_entity(shop_entity)
        DrinkKing::Entity::ReviewsExtraction.new(
          name: shop_entity.name,
          reviews: DrinkKing::Mapper::ReviewExtractionMapper.rebuild_many(shop_entity.reviews)
        )
      end
      private_class_method :rebuild_entity
    end
  end
end
