def add_gems
  gem 'devise'                  if add_devise?
  gem 'omniauth-facebook'       if add_omniauth_facebook?
  gem 'omniauth-google-oauth2'  if add_omniauth_google?
  gem 'omniauth-twitter'        if add_omniauth_twitter?
  gem 'hotwire-rails'           if add_hotwire?
  gem 'stimulus_reflex'         if add_stimulus_reflex?
  gem 'strong_migrations'
  gem 'bundler-audit'
  gem 'lograge'

  gem_group :development, :test do
    gem 'rspec-rails' if add_rspec?
  end

  gem_group :development do
    gem 'happy_gemfile'
    gem 'bullet'
    gem 'brakeman'
  end
end
