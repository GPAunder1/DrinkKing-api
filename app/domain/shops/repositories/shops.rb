# frozen_string_literal: true

module DrinkKing
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
        Database::ShopOrm.where(Sequel.like(:name, "%#{shopname}%")).all.map do |shop|
        rebuild_entity(shop)
        end
      end

      def self.find_many_shops(shopnames)
        # shopnames.map { |shopname| Shops.find_shop(shopname)}
        result = []
        shopnames.map do |shopname|
          Shops.find_shop(shopname).map {|single_shop| result << single_shop}
        end
        result
      end

      def self.find_placeid(placeid)
        db_record = Database::ShopOrm.first(placeid: placeid)
        rebuild_entity(db_record)
      end

      def self.find_or_create(entity)
        find_record = find(entity)
        return find_record if find_record

        db_shop = PersistShop.new(entity).call
        rebuild_entity(db_shop)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Shop.new(
          db_record.to_hash.merge(
            reviews: Reviews.rebuild_many(db_record.reviews)
          )
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
              db_shop.add_review(Reviews.create(review))
            end
          end
        end
      end
      private_class_method :rebuild_entity
    end
  end
end
