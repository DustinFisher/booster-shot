def install_devise
  return unless add_devise?

  generate "devise:install"
  generate "devise", 'User'
  inject_into_file 'config/environments/development.rb',
    after: "config.action_mailer.perform_caching = false\n" do <<-RUBY

  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
    RUBY
  end

  inject_into_file 'config/environments/test.rb',
    after: "config.action_mailer.perform_caching = false\n" do <<-RUBY

  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
    RUBY
  end

  add_marketing_homepage

  route "root to: 'marketing_page#index'"
end
