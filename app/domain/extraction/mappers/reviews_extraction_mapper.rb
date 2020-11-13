# frozen_string_literal: false

require 'ckip_client'

module CodePraise
  module Mapper
    # Class for ReviewsExtractionMapper
    class ReviewsExtractionMapper
      def self.find_by_shopid(shop_id)
        shop_entity = CodePraise::Repository::Shops.find_id(shop_id)
        shop_entity.reviews
      end
    end
  end
end
