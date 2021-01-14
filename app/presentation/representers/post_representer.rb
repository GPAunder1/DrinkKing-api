# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module DrinkKing
  module Representer
    # Represent drink as json
    class Post < Roar::Decorator
      include Roar::JSON

      property :text
      property :img_url
      property :post_time

    end
  end
end
