# frozen_string_literal: false

module CodePraise
  module Entity
    # class for ReviewExtraction
    class ReviewExtraction < Dry::Struct
      include Dry.Types

      attribute :id,              Strict::Integer.optional
      attribute :author,          Strict::String
      attribute :rating,          Strict::Integer
      attribute :relative_time,   Strict::String
      attribute :content,         Strict::String
      attribute :characters,      Strict::Array.of(String)

      def mention_drink
        Value::DrinkGrappler.new.mention_drink(characters)
      end

      def getcharacters
        characters
      end
    end
  end
end
