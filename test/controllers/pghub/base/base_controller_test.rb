require 'test_helper'

module Pghub::Base
  class BaseControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get create" do
      get base_create_url
      assert_response :success
    end

  end
end
