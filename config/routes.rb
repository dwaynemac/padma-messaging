Messaging::Application.routes.draw do
  namespace 'v0' do
    resources :messages, only: :create
  end
end
