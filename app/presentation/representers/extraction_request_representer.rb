# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

# Represents essential Repo information for API output
module DrinkKing
  module Representer
    # Representer object for extraction clone requests
    class ExtractionRequest < Roar::Decorator
      include Roar::JSON

      property :shop_id
      property :id
    end
  end
end
