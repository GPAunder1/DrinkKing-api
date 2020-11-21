# frozen_string_literal: true

require_relative 'helpers/spec_helper'
require_relative 'helpers/database_helper'
require_relative 'helpers/vcr_helper'
require 'headless'
require 'watir'

describe 'Acceptance Tests' do
  DatabaseHelper.setup_database_cleaner

  before do
    DatabaseHelper.wipe_database
    # @headless = Headless.new

    # Specify the driver path - failed :(
    # driver = Selenium::WebDriver::Driver.for(:remote, url: "http://localhost:9515")
    # @browser = Watir::Browser.start('blank', driver, headless: true)

    # Specify the driver path - failed :(
    # chromedriver_path = 'spec/helpers/chromedriver.exe'
    # Selenium::WebDriver::Chrome::Service.driver_path = chromedriver_path
    @browser = Watir::Browser.new :safari
  end

  after do
    @browser.close
    # @headless.destroy
  end

  describe 'HomePage' do
    describe 'Visit index page' do
      it '(HAPPY) should not see any shop before search' do
        # GIVEN: user is on the index page without any search
        @browser.goto homepage
        # THEN: user should see header and search box and empty table
        _(@browser.h1(id: 'main_header').text).must_equal 'DrinkKing'
      end
    end
  end
end
