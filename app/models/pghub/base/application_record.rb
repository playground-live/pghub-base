module Pghub
  module Base
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
