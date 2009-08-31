ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'statuses'
  
  map.resources :statuses, :collection => {:mentions => :get, :favorites => :get},
                            :member => {:fav => :post, :unfav => :post}
  map.resources :direct_messages
  map.resources :users, :has_one => [:password, :confirmation]
  map.setup_sprint 'setup_sprint_account', :controller => 'users', :action => 'setup_sprint' 
  map.resources :passwords
  map.resources :friendships
  
  map.resource :session
  map.finalize_session 'session/finalize', :controller => 'sessions', :action => 'finalize'  
end
