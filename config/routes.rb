Pfitmap::Application.routes.draw do

  get 'protein_counts_by_rank', to: 'protein_counts#by_rank'
  get 'protein_counts_with_enzymes', to: 'protein_counts#with_enzymes'
  get 'protein_counts_by_hierarchy', to: 'protein_counts#by_hierarchy'
  
  resources :proteins

  resources :taxons do
    get '/ajax_list', to: 'taxons#ajax_list'
    get '/ajax_list_protein_counts', to: 'taxons#ajax_list_protein_counts'
  end

  resources :enzymes

  match '/auth/:provider/callback', to: 'sessions#create'
  match '/auth/failure', to: 'sessions#failure'
  match '/signout' => "sessions#destroy", :as => :signout

  resources :pfitmap_releases do
    post 'make_current', :as => :make_current
    post 'calculate', :as => :calculate
  end

  resources :db_sequences

  resources :hmm_db_hits

  resources :hmm_result_rows, :except => [:index, :new]

  resources :hmm_results, :except => [:new, :edit]

  resources :sequence_sources do
    post 'evaluate', :as => :evaluate
  end
  
  resources :hmm_profiles do
    resources :hmm_results, :only => [:new, :edit, :create]
  end

  resources :users

  resources :hmm_score_criteria
  
  post 'change_release' => 'sessions#change_release'

  root to: "static_pages#home"
  
  get '/help', to: 'static_pages#help'
  get '/contact', to: 'static_pages#contact'
  get '/sign_in', to: 'static_pages#sign_in'

  get "/404", :to => "static_pages#error_404"

  #  get "home/index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
