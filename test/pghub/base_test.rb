require 'test_helper'

class Pghub::Base::Test < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Pghub::Base
  end
end
