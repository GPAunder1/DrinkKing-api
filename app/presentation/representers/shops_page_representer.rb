# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'shop_page_representer'

module DrinkKing
  module Representer
    # Represent shop lists for API output
    class ShopsPage < Roar::Decorator
      include Roar::JSON

      collection :shops_page, extend: Representer::ShopPage,
                         class: OpenStruct
    end
  end
end
