Coworfing::Application.routes.draw do


    match 'tags/:tag' => 'places#index', via: :get, as: :tag

    match 'about' => 'home#about', via: :get, as: :about

    match 'press' => 'home#press', via: :get, as: :press

    match 'map' => 'home#map', via: :get, as: :map
    match 'mobile' => 'home#mobile', via: :get, as: :mobile

    match 'profile/:username' => 'users#show', via: :get, as: :profile
    match 'people' => 'users#index', via: :get, as: :people

    # temporary route for mobile app
    match 'en/places' => 'places#index', via: :get

    devise_for :users,
      skip: [:sessions],
      controllers: {
        invitations: 'users/invitations',
        registrations: 'registrations',
        omniauth_callbacks: 'omniauth_callbacks' }

    as :user do
      get 'login' => 'devise/sessions#new', as: :new_user_session
      post 'login' => 'devise/sessions#create', as: :user_session
      delete 'logout' => 'devise/sessions#destroy', as: :destroy_user_session

      get 'settings' => 'registrations#edit', as: :user_settings_edit
      put 'settings' => 'registrations#update', as: :user_settings_update

      put "settings/password" => 'registrations#update', as: :user_password_update
      get "settings/password" => 'registrations#password', as: :user_password_edit
    end

    authenticated :user do
        root to: 'home#map'
    end

    resources :users, :only => [:index, :edit, :update]

    get 'l' => 'places#index', via: :get
    get 'l/:cities' => 'places#index', via: :get

    resources :places do
      resources :comments, :only => :create

      get 'submitted', on: :collection, as: :submitted
      get 'page/:page', action: :index, on: :collection

      get 'works', controller: :checkins, action: :works, as: :works
      get 'worked', controller: :checkins, action: :worked, as: :worked
      get 'uncheck', controller: :checkins, action: :uncheck, as: :uncheck
    end

    resources :demands, :only => [:create, :index] do
      put "accept", on: :member
    end

    resources :place_requests, path: 'requests' do
      get 'approve', on: :member
      get 'reject', on: :member
      get 'received', on: :collection
      get 'sent', on: :collection
    end

    resources :organizations do
      resources :memberships
    end

    root :to => "home#map"
end

