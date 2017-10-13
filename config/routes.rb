Pghub::Base::Engine.routes.draw do
  post '/' => 'webhooks#create'
end
