# frozen_string_literal: true

module CodePraise
  module Repository
    # Class for Shop
    class Shops
      def self.all
        Database::ShopOrm.all.map { |db_shop| rebuild_entity(db_shop) }
      end

      def self.find_id(id)
        rebuild_entity Database::ShopOrm.first(id: id)
      end

      def self.find_shop(shopname)
        rebuild_entity Database::ShopOrm.first(name: shopname)
      end

      def self.rebuild_entity(db_record)
        return nil unless records

        Entity::Shop.new(
          id: db_record.id,
          placeid: db_record.placeid,
          name: db_record.name,
          address: db_record.address,
          location: db_record.location,
          phone_number: db_record.phone_number,
          map_url: db_record.map_url,
          opening_now: db_record.opening_now,
          rating: db_record.rating,
          reviews: db_record.reviews
        )
      end

      def self.db_find_or_create(entity)
        Database::ShopOrm.find_or_create(entity.to_attr_hash)
      end

      private_class_method :rebuild_entity, :db_find_or_create
    end
  end
end
