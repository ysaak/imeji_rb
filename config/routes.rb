Rails.application.routes.draw do
  get 'help' => 'help_pages#home', as: :help_home
  get 'help/search' => 'help_pages#search', as: :help_search

  get 'welcome/index'
  get 'init' => 'welcome#init'


  get 'wallpaper/:id' => 'wallpapers#show', as: :wallpaper

  get  'search/color/:color' => 'wallpapers#search', as: :search_color
  post 'search' => 'wallpapers#search', as: :search
  get  'search/tags.json' => 'wallpapers#tag_search', as: :tags_search

  post 'wallpaper/:id/edit' => 'wallpapers#edit', as: :wallpaper_edit

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'wallpapers#index'

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
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
