# frozen_string_literal: false

module CodePraise
  module Entity
    # Domain entity for drink shops' reviews
    class Review < Dry::Struct
      include Dry.Types

      attribute :id,              Strict::Integer.optional
      attribute :author,          Strict::String
      attribute :rating,          Strict::Integer
      attribute :relative_time,   Strict::String
      attribute :content,         Strict::String
    end
  end
end
