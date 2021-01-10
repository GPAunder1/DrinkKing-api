# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'post_representer'

module DrinkKing
  module Representer
    # Represent menu as json
    class ShopPage < Roar::Decorator
      include Roar::JSON

      property :shopname
      collection :posts, extend: Representer::Post, class: OpenStruct
    end
  end
end
