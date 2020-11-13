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
    end
  end
end
