# frozen_string_literal: true

require 'sequel'

module CodePraise
  module Database
    # Object Relational for reviews
    class ReviewOrm < Sequel::Model(:reviews)
      many_to_one :shop,
                  class: :'CodePraise::Database::ShopOrm'

      plugin :timestamps, update_on_create: true
      def self.db_find_or_create(review_info)
        first(id: review_info['shop_id']) || create(review_info)
      end
    end
  end
end
