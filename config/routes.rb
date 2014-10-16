require 'sidekiq/web'

Rails.application.routes.draw do
  get 'userpanel/configreport'

  get 'userpanel/displayreport'

  devise_for :admins, controllers: { sessions: "admins/sessions" }
  get 'userpanel/configreport', as: 'user_root'

  get 'userpanel/update_selarea', as: 'update_selarea'
  post 'userpanel/update_area', as: 'update_area'
  post 'userpanel/clear_area', as: 'clear_area'
  get 'userpanel/show'
  post 'userpanel/saveprofile'

  get 'manage/jobs', as: 'admin_root'

  devise_for :users
  get 'area/volumeview'

  get 'area/priceview'

  get 'area/volumegraph'

  get 'area/pricevolume'

  get 'county/volumeview' => 'county#volumeview' , as: 'county_priceview'

  get 'county/priceview'

  get 'county/pricingview' => 'county#pricingview', as: 'county_pricingview'

  get 'county/volumegraph'

  get 'county/pricevolume'

  get 'scraper/search'

  get 'scraper/contactus'

  get 'county/searcharea'

  get 'county/searcharea' => 'county#searcharea', as: 'countysearcharea'

  get 'scraper/result'

  get 'scraper/aboutus'

  get 'county/pricevolume/:county' => 'county#pricevolume', as:  'countyvol'

  get 'county/pricingvolume/:county' => 'county#pricingvolume', as:  'countyprice'

  get 'county/detail'

  get 'county/pricevolume/detail/:searchparam' => 'county#detail', as: 'detailvol'

  #resources :snippets
  #root to: "snippets#new"
  mount Sidekiq::Web, at: "manage/sidekiq"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :manage do
  #     # Directs /manage/products/* to Admin::ProductsController
  #     # (app/controllers/manage/products_controller.rb)
  #     resources :products
  #   end
end
