# frozen_string_literal: true

require_relative '../helpers/acceptance_helper'
require_relative 'pages/shop_page'
require_relative 'pages/index_page'

describe 'ShopPage Acceptance Tests' do
  include PageObject::PageFactory
  DatabaseHelper.setup_database_cleaner

  before do
    DatabaseHelper.wipe_database
    # @headless = Headless.new
    @browser = Watir::Browser.new
  end

  after do
    @browser.close
    # @headless.destroy
  end

  describe 'Shop Page' do
    it '(HAPPY) should see shop place on map if found shop' do
      # GIVEN: user requests and search by a keyword
      visit IndexPage do |page|
          page.search_keyword(KEYWORD)
      end

      # WHEN: user goes to the shop page
      on_page(ShopPage, using_params: { keyword: KEYWORD }) do |page|
        # THEN: they should see the shop map on shop page
        _(page.shop_map_element.present?).must_equal true
        _(page.shop_list_element.present?).must_equal false
      end
    end

    it '(HAPPY) should be able to switch between shop map and shop list' do
      # GIVEN: user requests and search by a keyword
      visit IndexPage do |page|
          page.search_keyword(KEYWORD)
      end

      # WHEN: user goes to the shop page
      on_page(ShopPage, using_params: { keyword: KEYWORD }) do |page|
        # WHEN: and click on list button
        page.list_button
        # THEN: they should see shop list
        _(page.shop_map_element.present?).must_equal false
        _(page.shop_list_element.present?).must_equal true

        # WHEN: and they click on map button
        page.map_button
        # THEN: they should see map list
        _(page.shop_map_element.present?).must_equal true
        _(page.shop_list_element.present?).must_equal false
      end
    end

    it '(HAPPY) should be able to interact with shop map' do
      # GIVEN: user requests and search by a keyword
      visit IndexPage do |page|
          page.search_keyword(KEYWORD)
      end

      # WHEN: user goes to the shop page
      on_page(ShopPage, using_params: { keyword: KEYWORD }) do |page|
        # WHEN: and click a marker on the shop map
        page.marker_on_map_element.click
        # THEN: they should see a toast window displaying single shop information
        _(page.toast_window_element.present?).must_equal true

        # WHEN: and they click the menu button on toast window
        page.menu_button
        Watir::Wait.until{ page.panel_animation_done?(page.menu_panel_element) }
        # THEN: they should see the menu panel
        _(page.menu_panel_element.present?).must_equal true

        # WHEN: and they click back button on menu panel
        page.menu_back_button
        Watir::Wait.until{ page.panel_animation_done?(page.menu_panel_element) }

        # THEN: they should be back to the toast window
        _(page.menu_panel_element.present?).must_equal false
        _(page.toast_window_element.present?).must_equal true

        # WHEN: and they click the "Show Reviews" button on toast window
        page.review_button
        Watir::Wait.until{ page.panel_animation_done?(page.review_panel_element) }
        # THEN: they should see the reviews panel
        _(page.review_panel_element.present?).must_equal true

        # WHEN: and they click back button on reviews panel
        page.review_back_button
        Watir::Wait.until{ page.panel_animation_done?(page.review_panel_element) }
        # THEN: they should be back to the toast window
        _(page.review_panel_element.present?).must_equal false
        _(page.toast_window_element.present?).must_equal true

        # WHEN: and they click close button on toast window
        page.close_button
        Watir::Wait.until{ page.toast_animation_done?(page.toast_window_element) }

        # THEN: the toast window should be closed
        _(page.toast_window_element.present?).must_equal false
      end
    end

    it '(HAPPY) should be able to interact with shop list' do
      # GIVEN: user requests and search by a keyword
      visit IndexPage do |page|
          page.search_keyword(KEYWORD)
      end

      # WHEN: user goes to the shop page
      on_page(ShopPage, using_params: { keyword: KEYWORD }) do |page|
        # WHEN: and click on list button
        page.list_button
        # WHEN: and click on "show reviews" button
        page.shoplist_first_review_button
        Watir::Wait.until{page.modal_animation_done?(page.shoplist_first_shop_reviews_element)}
        # THEN: they should see the reviews model
        _(page.shoplist_first_shop_reviews_element.present?).must_equal true

        # WHEN: and click on "show reviews" button again
        page.shoplist_first_review_button
        Watir::Wait.until{page.modal_animation_done?(page.shoplist_first_shop_reviews_element)}
        # THEN: the reviews model should be closed
        _(page.shoplist_first_shop_reviews_element.present?).must_equal false
      end
    end

    it '(BAD) should report error if no shop is found' do
      # GIVEN: user go directly to shop page that doesn't have shop
      visit(ShopPage, using_params: { keyword: GARBLE })

      # THEN: they should see error message
      on_page IndexPage do |page|
        _(page.warning_message).must_equal 'No shop is found!'
      end
    end
  end
end
