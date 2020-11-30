# frozen_string_literal: true

require_relative '../helpers/acceptance_helper'
require_relative 'pages/index_page'

describe 'Homepage Acceptance Tests' do
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

  describe 'Visit index page' do
    it '(HAPPY) should not see any shop before search' do
      # GIVEN: user hasn not do any search
      # WHEN: user visit the index page
      visit IndexPage do |page|
        # THEN: user should see header and search box and empty table
        _(page.title_heading).must_equal 'DrinkKing'
        _(page.keyword_input_element.present?).must_equal true
        _(page.search_button_element.present?).must_equal true
        _(page.search_record_card_body.empty?).must_equal true
      end
    end
  end

  describe 'Search keyword' do
    it '(HAPPY) should be able to search' do
      # GIVEN: user is on the index page
      visit IndexPage do |page|
        # WHEN: user search a keyword
        page.search_keyword(KEYWORD)
        # THEN: user to see shop's page
        @browser.url.include? KEYWORD
      end
    end

    it '(HAPPY) should be able to see search recordafter search' do
      # GIVEN: user has searched a keyword
      visit IndexPage do |page|
        page.search_keyword(KEYWORD)
      end

      # WHEN they return to the index page
      visit IndexPage do |page|
        # THEN: they should see search record
        _(page.first_record.text).must_include KEYWORD
      end
    end

    it '(BAD) should not be able to search invalid keyword' do
      # GIVEN: user is on the index page
      visit IndexPage do |page|
        # WHEN: user search invalid keyword
        page.search_keyword(GARBLE)
        # THEN: user should see a error message
        _(page.warning_message).must_equal 'Please enter keyword related to drink'
      end
    end
  end
end
