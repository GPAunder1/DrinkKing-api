# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module DrinkKing
  module Representer
    # Represent review as json
    class Review < Roar::Decorator
      include Roar::JSON

      property :author
      property :rating
      property :relative_time
      property :content

    end
  end
end
