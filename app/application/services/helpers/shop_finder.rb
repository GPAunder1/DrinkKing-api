# frozen_string_literal: true

require 'json'

module DrinkKing
  module Service
    # find shop in menu by specfic drink or shopname
    class ShopFinder
      def initialize(keyword, searchby = nil)
        @menu = ShopFinder.load_menu
        @keyword = keyword
        @searchby = searchby
      end

      def find
        if @searchby == 'shop'
          reduce_to_shopname(search_by_shopname(@keyword))
        elsif @searchby == 'drink'
          reduce_to_shopname(search_by_drinkname(@keyword))
        else
          reduce_to_shopname((search_both(@keyword)))
        end
        # must return array of shopname list
      end

      def find_shopname_and_menu
        if @searchby == 'shop'
          search_by_shopname(@keyword)
        elsif @searchby == 'drink'
          search_by_drinkname(@keyword)
        else
          search_both(@keyword)
        end
        # must return array of shopname list
      end

      def show_all
        @menu
      end

      private

      def reduce_to_shopname(full_list)
        result = []
        full_list.map { |hash| result << hash['shopname'] }
        result
      end

      def self.load_menu
        file = File.read('assets/shops_menu.json')
        JSON.parse(file)
      end

      def search_by_shopname(keyword)
        result = []
        @menu.map { |shop_menu| result << shop_menu if shop_menu['shopname'].include? keyword }
        result
      end

      def search_by_drinkname(keyword)
        result = []
        # return all menu
        @menu.map do |shop_menu|
          result << shop_menu unless shop_menu['drinks'].select { |drink| drink['name'].include?keyword }.empty?
        end
        # @menu.map do |shop_menu|
        #   select_shop = { 'shopname' => '', 'drinks' => [] }
        #   drinks = []
        #   shop_menu['drinks'].map { |drink| drinks << drink['name'] if drink['name'].include?keyword }
        #   select_shop['shopname'] = shop_menu['shopname']
        #   select_shop['drinks'] = drinks
        #   result << select_shop unless drinks.empty?
        # end
        result
      end

      def search_both(keyword)
        search_by_shopname_list = search_by_shopname(keyword)
        search_by_drinkname_list = search_by_drinkname(keyword)
        (search_by_shopname_list + search_by_drinkname_list).uniq
      end
    end
  end
end
