# frozen_string_literal: true

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock
end

RSpec.describe "QuiverParser" do
  describe "export" do
    it "finds the notebook and adds items to the list" do
      # VCR asserts that the correct request is being made
      VCR.use_cassette("create_tasks") do
        with_modified_env(
          WL_ACCESS_TOKEN: "test",
          WL_CLIENT_ID: "test",
          NOTEBOOK_DIR: "./spec/support/files/quiver.qvlibrary",
        ) do
          require "./app/quiver_parser"
          QuiverParser.new.export
        end
      end
    end
  end

  def with_modified_env(options, &block)
    ClimateControl.modify(options, &block)
  end
end
