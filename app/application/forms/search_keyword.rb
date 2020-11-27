# frozen_string_literal: true

require 'dry-validation'

module DrinkKing
  module Forms
    class SearchKeyword < Dry::Validation::Contract
      checklist = %w[飲料 可不可 可不可熟成紅茶 鮮茶道 大苑子 荔枝烏龍 胭脂多多]

      params do
        required(:search_keyword).filled(:string)
      end

      rule(:search_keyword) do
        unless checklist.include? value
          key.failure('Please enter keyword related to drink')
        end
      end
    end
  end
end
