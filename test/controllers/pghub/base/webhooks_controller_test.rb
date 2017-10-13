require 'test_helper'

module Pghub::Base
  class WebhooksControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get create" do
      get webhooks_create_url
      assert_response :success
    end

  end
end
