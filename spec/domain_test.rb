# frozen_string_literal: false

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'
require_relative 'helpers/database_helper'

describe 'Development_test_by_Tim' do
  VcrHelper.setup_vcr
  DatabaseHelper.setup_database_cleaner

  before do
    VcrHelper.configure_vcr_for_googlemap
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'domain_review_mapper' do
    it 'create_review_extraction_entity' do
      # places = CodePraise::Googlemap::ShopMapper.new(TOKEN).find(KEYWORD)
      rebuilt = CodePraise::Mapper::ReviewExtractionMapper.find_by_shopid(22)
      puts rebuilt
    end
  end
end
