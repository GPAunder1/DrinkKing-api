# frozen_string_literal: false

module DrinkKing
  module Entity
    # class for ReviewExtraction
    class ReviewExtraction < Dry::Struct
      include Dry.Types

      attribute :id,              Strict::Integer.optional
      attribute :author,          Strict::String
      attribute :rating,          Strict::Integer
      attribute :relative_time,   Strict::String
      attribute :content,         Strict::String
      attribute :tokens,          Strict::Array.of(String)

      def mention_drink
        Value::DrinkGrappler.new.mention_drink(tokens)
      end

      # def getcharacters
      #   tokens
      # end
    end
  end
end
