def install_devise
  return unless add_devise?

  generate "devise:install"
  generate "devise", 'User'
  devise_action_mailer_dev_config
  devise_action_mailer_test_config
  add_basic_sign_up_in_links
  add_basic_flash_messages
  add_marketing_homepage
  add_user_home_controller

  route "root to: 'marketing_page#index'"
  route <<-ROUTE
    authenticated :user do
      root 'users/home#index', as: :authenticated_root
    end
  ROUTE
end

def devise_action_mailer_dev_config
  inject_into_file 'config/environments/development.rb',
    after: "config.action_mailer.perform_caching = false\n" do <<-RUBY

  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
    RUBY
  end
end

def devise_action_mailer_test_config
  inject_into_file 'config/environments/test.rb',
    after: "config.action_mailer.perform_caching = false\n" do <<-RUBY

  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
    RUBY
  end
end

def add_basic_sign_up_in_links
  return if add_base_style?

  directory 'app/views/devise/menu'
  inject_into_file 'app/views/layouts/application.html.erb',
    after: "<body>\n" do <<-RUBY
    <%= render 'devise/menu/registration_items' %>
    <%= render 'devise/menu/login_items' %>
    RUBY
  end
end

def add_basic_flash_messages
  return if add_base_style?

  inject_into_file 'app/views/layouts/application.html.erb',
    after: "<body>\n" do <<-RUBY
    <p class="notice"><%= notice %></p>
    <p class="alert"><%= alert %></p>
    RUBY
  end
end

def add_marketing_homepage
  copy_file 'app/controllers/marketing_page_controller.rb'
  copy_file 'app/views/marketing_page/index.html.erb'
end

def add_user_home_controller
  copy_file 'app/controllers/users/home_controller.rb'
  copy_file 'app/views/users/home/index.html.erb'
end
