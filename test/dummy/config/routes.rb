Rails.application.routes.draw do
  mount Pghub::Base::Engine => "/pghub-base"
end
