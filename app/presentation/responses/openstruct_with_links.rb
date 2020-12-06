# frozen_string_literal: true

module DrinkKing
  module Response
    # OpenStruct for deserializing json with hypermedia
    class OpenStructWithLinks < OpenStruct
      attr_accessor :links
    end
  end
end
