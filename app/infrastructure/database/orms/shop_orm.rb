# frozen_string_literal: true

require 'sequel'

module DrinkKing
  module Database
    # Object Relational for shops
    class ShopOrm < Sequel::Model(:shops)
      one_to_many :reviews,
                  class: :'DrinkKing::Database::ReviewOrm',
                  key: :shop_id
      plugin :timestamps, update_on_create: true

      # def self.find_or_create(shop_info)
      #   first(placeid: shop_info['placeid']) || create(shop_info)
      # end
    end
  end
end
