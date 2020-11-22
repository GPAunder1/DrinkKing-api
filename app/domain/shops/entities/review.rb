# frozen_string_literal: false

module DrinkKing
  module Entity
    # Domain entity for drink shops' reviews
    class Review < Dry::Struct
      include Dry.Types

      attribute :id,              Strict::Integer.optional
      attribute :author,          Strict::String
      attribute :rating,          Strict::Integer
      attribute :relative_time,   Strict::String
      attribute :content,         Strict::String

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key }
      end
    end
  end
end
