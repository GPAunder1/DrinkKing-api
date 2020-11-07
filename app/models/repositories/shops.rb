# frozen_string_literal: true

module CodePraise
  module Repository
    # Class for Shop
    class Shops
      def self.all
        Database::ShopOrm.all.map { |db_shop| rebuild_entity(db_shop) }
      end

      def self.find(entity)
        find_placeid(entity.placeid)
      end

      def self.find_id(id)
        rebuild_entity Database::ShopOrm.first(id: id)
      end

      def self.find_shop(shopname)
        rebuild_entity Database::ShopOrm.first(name: shopname)
      end

      def self.find_placeid(placeid)
        db_record = Database::ShopOrm.first(placeid: placeid)
        rebuild_entity(db_record)
      end

      def self.db_find_or_create(entity)
        Database::ShopOrm.find_or_create(entity.to_attr_hash)
      end

      def self.create(entity)
        raise 'Shop already exists' if find(entity)

        db_shop = PersistShop.new(entity).call
        rebuild_entity(db_shop)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Shop.new(
          db_record.to_hash.merge(
            reviews: Reviews.rebuild_many(db_record.reviews)
          )
          # id: db_record.id,
          # placeid: db_record.placeid,
          # name: db_record.name,
          # address: db_record.address,
          # location: db_record.location,
          # phone_number: db_record.phone_number,
          # map_url: db_record.map_url,
          # opening_now: db_record.opening_now,
          # rating: db_record.rating,
          # reviews: db_record.reviews
        )
      end

      private

      # Helper class to persist project and its members to database
      class PersistShop
        def initialize(entity)
          @entity = entity
        end

        def create_shop
          Database::ShopOrm.create(@entity.to_attr_hash)
        end

        def call
          create_shop.tap do |db_shop|
            @entity.reviews.each do |review|
              db_shop.add_review(Reviews.db_find_or_create(review))
            end
          end
        end
      end
      private_class_method :rebuild_entity
    end
  end
end
