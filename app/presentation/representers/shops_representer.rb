# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'shop_representer'

module DrinkKing
  module Representer
    # Represent shop lists for API output
    class ShopsList < Roar::Decorator
      include Roar::JSON

      collection :shops, extend: Representer::Shop,
                         class: OpenStruct
    end
  end
end
