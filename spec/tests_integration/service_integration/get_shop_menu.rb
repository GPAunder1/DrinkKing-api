# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'
require_relative '../../helpers/database_helper'

describe 'get shop menu test' do
  VcrHelper.setup_vcr
  DatabaseHelper.setup_database_cleaner

  before do
    VcrHelper.configure_vcr_for_googlemap(recording: :new_episodes)
  end

  after do
    VcrHelper.eject_vcr
  end
  it 'get shop menu' do
    search_keyword = DrinkKing::Request::SearchKeyword.new(KEYWORD)
    DrinkKing::Service::AddShops.new.call(search_keyword: search_keyword)
    result = DrinkKing::Service::ShopMenu.new.call(keyword: KEYWORD).value!.message[0]
    _(result['shopname']).must_include KEYWORD
  end
end
