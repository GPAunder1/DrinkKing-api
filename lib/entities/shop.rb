# frozen_string_literal: false

module CodePraise
  module Entity
    # Domain entity for drink shops
    class Shop < Dry::Struct
      include Dry.Types

      attribute :name,        Strict::String
      attribute :address,     Strict::String
      attribute :location,    Strict::Hash
      attribute :opening_now, Strict::Bool.optional
      attribute :rating,      Strict::Integer | Strict::Float
    end
  end
end
