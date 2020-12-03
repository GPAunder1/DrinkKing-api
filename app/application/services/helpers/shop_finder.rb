# frozen_string_literal: true

module DrinkKing
  module Service
    # find shop in menu by specfic drink or shopname
    class ShopFinder
      def initialize(keyword, searchby = nil)
        @keyword = keyword
        @searchby = searchby
      end

      def find
        if @searchby == 'shop'
          search_by_shopname(@keyword)
        elsif @searchby == 'drink'
          search_by_drinkname(@keyword)
        else
          search_both(@keyword)
        end
        # must return array of shopname list
      end

      private

      def load_menu
        # File.read(menu.json)
        # menu is in asset/shops_menu.json
      end

      def search_by_shopname(keyword)

      end

      def search_by_drinkname(keyword)

      end

      def search_both(keyword)
        search_by_shopname(keyword)
        search_by_drinkname(keyword)
        # 可能會噴錯 要再創個list，把上面兩個回傳的list再丟到同個list中
        # i.e [[search_by_shopname_list], [search_by_drinkname_list]] => [ combine_list ]
      end
    end
  end
end
