# frozen_string_literal: true

require 'sequel'

module CodePraise
  module Database
    # Object Relational for shops
    class ShopOrm < Sequel::Model(:shops)
      one_to_many :shop_id,
                  class: :'CodePraise::Database::ReviewOrm'
      plugin :timestamps, update_on_create: true
    end
  end
end
