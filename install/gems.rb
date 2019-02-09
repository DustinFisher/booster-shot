def add_gems
  gem 'devise'                  if add_devise?
  gem 'omniauth-facebook'       if add_omniauth_facebook?
  gem 'omniauth-google-oauth2'  if add_omniauth_google?
  gem 'omniauth-twitter'        if add_omniauth_twitter?
  gem 'webpacker'               if add_webpack?

  gem_group :development, :test do
    gem 'rspec-rails' if add_rspec?
  end
end
