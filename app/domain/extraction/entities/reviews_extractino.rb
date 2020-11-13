# frozen_string_literal: false

module CodePraise
  module Entity
    # class for ReviewExtraction
    class ReviewExtraction < Dry::Struct
      include Dry.Types
      attribute :name, Strict::String
      attribute :characters, Strict::Array.of(ReviewExtraction)
    end
  end
end
