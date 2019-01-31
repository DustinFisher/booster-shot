def go_go_template!
  add_template_repository_to_source_path

  # default install variables
  @tailwindcss  = true
  @devise       = true

  gather_user_input
  add_gems

  after_bundle do
    install_webpack
    install_devise
    install_tailwindcss

    create_and_migrate_db
    initial_project_commit_and_branch
  end
end

def gather_user_input
  return if no?('Would you like to customize any of the setup?')

  add_devise
  add_tailwindcss
end

def add_devise
  @devise = yes?('Do you want to add Devise?') ? @devise : false
end

def add_tailwindcss
  @tailwindcss = yes?('Would you like to add TailwindCSS?') ? @tailwindcss : false
end

def add_tailwindcss?
  @tailwindcss.present?
end

def add_devise?
  @devise
end

def add_webpack?
  add_tailwindcss?
end

def add_gems
  gem 'devise'    if add_devise?
  gem 'webpacker' if add_webpack?
end

def install_webpack
  return unless add_webpack?

  rails_command 'webpacker:install'
end

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

def add_marketing_homepage
  copy_file 'app/controllers/marketing_page_controller.rb'
  copy_file 'app/views/marketing_page/index.html.erb'
end

def install_tailwindcss
  return unless add_tailwindcss?

  run 'yarn add tailwindcss --dev'
  run './node_modules/.bin/tailwind init app/javascript/css/tailwind.js'
  copy_file 'app/javascript/css/tailwind.css'
  insert_into_file 'app/views/layouts/application.html.erb',
                   before: "</head>\n" do
    <<-RUBY
  <%= javascript_pack_tag 'application' %>
    <%= stylesheet_pack_tag 'application' %>
    RUBY
  end

  insert_into_file 'app/javascript/packs/application.js',
                   before: "console.log('Hello World from Webpacker')\n" do
    <<-RUBY
import "../css/tailwind.css";
    RUBY
  end

  gsub_file "app/javascript/packs/application.js",
            /console.log\('Hello World from Webpacker'\)\n/, ''

  insert_into_file '.postcssrc.yml',
                   after: "postcss-import: {}\n" do
    <<-RUBY
  tailwindcss: './app/javascript/css/tailwind.js'
    RUBY
  end
end

def create_and_migrate_db
  rake 'db:create'
  rake 'db:migrate'
end

def initial_project_commit_and_branch
  git :init
  git add: "-A ."
  git commit: "-n -m 'Intializing a new project'"
  git checkout: "-b development"
end

def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    source_paths.unshift(tempdir = Dir.mktmpdir('booster-shot-'))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      '--quiet',
      'https://github.com/dustinfisher/booster-shot.git',
      tempdir
    ].map(&:shellescape).join(' ')
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

go_go_template!
