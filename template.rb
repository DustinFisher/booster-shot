Dir[File.join(__dir__, 'install', '*.rb')].each { |file| require file }

def go_go_template!
  add_template_repository_to_source_path

  # default install variables
  @tailwindcss        = true
  @devise             = true
  @js_framework       = 'react'
  @omniauth           = true
  @omniauth_twitter   = true
  @omniauth_google    = true
  @omniauth_facebook  = true

  gather_user_input

  add_gems

  use_js_not_coffee

  after_bundle do
    install_webpack
    install_devise
    install_tailwindcss
    install_js_framework

    create_db
    migrate_db
    stop_spring

    install_omniauth

    migrate_db
    initial_project_commit_and_branch
  end
end

def stop_spring
  run 'spring stop'
end

def gather_user_input
  return if no?('Would you like to customize any of the setup?')

  input_add_devise
  input_add_tailwindcss
  input_add_js_framework
  input_add_omniauth
end

def input_add_devise
  @devise = yes?('Do you want to add Devise?') ? @devise : false
end

def input_add_tailwindcss
  @tailwindcss = yes?('Would you like to add TailwindCSS?') ? @tailwindcss : false
end

def input_add_js_framework
  @js_framework = ask('Would you like a JS Framework?',
                      limited_to: %w[angular react elm stimulus none])
end

def input_add_omniauth
  return @omniauth = false unless yes?('Would you like to add Omniauth?')

  @omniauth_twitter   = yes?('Would you like to add Twitter Omniauth?') ? @omniauth_twitter : false
  @omniauth_google    = yes?('Would you like to add Google Omniauth?') ? @omniauth_google : false
  @omniauth_facebook  = yes?('Would you like to add Facebook Omniauth?') ? @omniauth_facebook : false
end

def add_tailwindcss?
  @tailwindcss.present?
end

def add_js_framework?
  @js_framework != 'none'
end

def add_devise?
  @devise
end

def add_webpack?
  add_tailwindcss?
end

def use_js_not_coffee
  inject_into_file 'config/application.rb',
    after: "config.load_defaults 5.2\n" do <<-RUBY

    config.generators.javascript_engine = :js
    RUBY
  end
end

def create_db
  rake 'db:create'
end

def migrate_db
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
