def install_omniauth
  return unless add_omniauth?

  add_providers_to_user_model
  add_callback_route_to_users
  add_omniauth_providers_to_config
  add_identities_model_for_multi_login
  add_has_many_identities_to_user
  add_callback_controller
end

def add_omniauth?
  @omniauth
end

def add_omniauth_twitter?
  @omniauth_twitter
end

def add_omniauth_google?
  @omniauth_google
end

def add_omniauth_facebook?
  @omniauth_facebook
end

def add_providers_to_user_model
  insert_into_file(
    'app/models/user.rb',
    'omniauthable, :',
    after: 'devise :'
  )
end

def add_callback_route_to_users
  insert_into_file(
    'config/routes.rb',
    ', controllers: { omniauth_callbacks: \'users/omniauth_callbacks\' }',
    after: '  devise_for :users'
  )
end

def add_omniauth_providers_to_config
  add_twitter_config  if add_omniauth_twitter?
  add_google_config   if add_omniauth_google?
  add_facebook_config if add_omniauth_facebook?
end

def add_identities_model_for_multi_login
  generate :model, 'Identity', 'user:references provider:string uid:string access_token:string access_token_secret:string'
end

def add_has_many_identities_to_user
  insert_into_file 'app/models/user.rb',
                   before: "end\n" do
    <<-RUBY

  has_many :identities

    RUBY
  end
end

def add_callback_controller
  template 'app/controllers/users/omniauth_callbacks_controller.rb.tt', force: true
end

def add_twitter_config
  insert_into_file 'config/initializers/devise.rb',
    before: "  # ==> Warden configuration" do
    <<-RUBY
  #config.omniauth(
  #   :twitter,
  #   Rails.application.credentials.twitter[:app_id],
  #   Rails.application.credentials.twitter[:app_secret]
  #)

    RUBY
  end
end

def add_google_config
  insert_into_file 'config/initializers/devise.rb',
    before: "  # ==> Warden configuration" do
    <<-RUBY
  #config.omniauth(
  #   :google_oauth2,
  #   Rails.application.credentials.google[:app_id],
  #   Rails.application.credentials.google[:app_secret]
  #)

    RUBY
  end
end

def add_facebook_config
  insert_into_file 'config/initializers/devise.rb',
    before: "  # ==> Warden configuration" do
    <<-RUBY
  #config.omniauth(
  #   :facebook,
  #   Rails.application.credentials.facebook[:app_id],
  #   Rails.application.credentials.facebook[:app_secret]
  #)

    RUBY
  end
end

def providers
  results = []
  results << :twitter if add_omniauth_twitter?
  results << :google_oauth2 if add_omniauth_google?
  results << :facebook if add_omniauth_facebook?

  results
end
