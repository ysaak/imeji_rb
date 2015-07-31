Rails.application.routes.draw do

  get 'help' => 'help#index', as: :help_index
  get 'help/:action' => 'help#:action', as: :help

  get 'welcome/index'
  get 'init' => 'welcome#init'

  get 'wallpaper/:id' => 'wallpapers#show', as: :wallpaper

  get 'search' => 'wallpapers#search', as: :search
  get 'search/tags.json' => 'tags#search', as: :tags_search
  get 'search/untagged' => 'wallpapers#untagged', as: :search_untagged

  post 'wallpaper/edit' => 'wallpapers#edit', as: :wallpaper_edit

  resources :tags

  namespace :admin do
    get 'wallpapers/import', as: :import_wallpaper
    post 'wallpapers/do_import', as: :do_import_wallpaper
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'wallpapers#index'
end
