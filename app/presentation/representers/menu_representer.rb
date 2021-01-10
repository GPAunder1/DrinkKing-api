# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'drink_representer'

module DrinkKing
  module Representer
    # Represent menu as json
    class Menu < Roar::Decorator
      include Roar::JSON

      property :shopname
      property :fb_url
      collection :drinks, extend: Representer::Drink, class: OpenStruct
    end
  end
end
