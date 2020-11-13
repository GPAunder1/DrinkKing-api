# frozen_string_literal: true

require 'sequel'

module CodePraise
  module Database
    # Object Relational for reviews
    class ReviewOrm < Sequel::Model(:reviews)
      many_to_one :shop,
                  class: :'CodePraise::Database::ShopOrm'

      plugin :timestamps, update_on_create: true
    end
  end
end
