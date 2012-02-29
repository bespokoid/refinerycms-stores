Refinery::Core::Engine.routes.draw do

  # Frontend routes
  namespace :stores do
    resources :stores, :only => [:index, :show]  do
      collection do
        post :add_to_cart
        post :empty_cart
        post :checkout
      end
    end
 
  end

  namespace :orders do
    resources :orders, :only => [:index, :show, :update, :edit] do
      member do
        post :purchase
        get  :cancel_order
        post  :re_edit
      end
    end
  end


  namespace :products do
    resources :products, :only => [:show]
  end


  # Admin routes
  namespace :stores, :path => '' do
    namespace :admin, :path => 'refinery' do
      resources :stores, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

  # Admin routes
  namespace :products, :path => '' do
    namespace :admin, :path => 'refinery' do
      resources :products, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end


  # Frontend routes
  namespace :orders do
    resources :orders, :path => '', :only => [:index, :show]
  end

  # Admin routes
  namespace :orders, :path => '' do
    namespace :admin, :path => 'refinery' do
      resources :orders, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

  # Admin routes
  namespace :addresses, :path => '' do
    namespace :admin, :path => 'refinery' do
      resources :addresses, :except => :show do
        collection do
          post :update_positions
        end
      end
    end
  end

end
