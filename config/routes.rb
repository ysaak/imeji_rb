Rails.application.routes.draw do

  get 'help' => 'help_pages#home', as: :help_home
  get 'help/search' => 'help_pages#search', as: :help_search

  get 'welcome/index'
  get 'init' => 'welcome#init'

  get 'wallpaper/:id' => 'wallpapers#show', as: :wallpaper

  get 'search' => 'wallpapers#search', as: :search
  get 'search/tags.json' => 'tags#search', as: :tags_search
  get 'search/untagged' => 'wallpapers#untagged', as: :search_untagged

  post 'wallpaper/edit' => 'wallpapers#edit', as: :wallpaper_edit

  resources :tags, except: [:edit]

  namespace :admin do
    get 'wallpapers/import', as: :import_wallpaper
    post 'wallpapers/do_import', as: :do_import_wallpaper

    resources :groups, except: [:show]
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'wallpapers#index'
end
