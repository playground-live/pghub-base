module Pghub
  module Base
    class Engine < ::Rails::Engine
      isolate_namespace Pghub::Base
    end
  end
end
