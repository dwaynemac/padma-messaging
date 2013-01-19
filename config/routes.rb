Messaging::Application.routes.draw do
  namespace 'v0' do
    resources :messages, only: :create
    resources :notify_me, only: [:index, :create] do
      collection do
        delete :destroy
      end
    end
  end
end
