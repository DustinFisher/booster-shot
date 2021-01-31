
def go_go_template!
  add_template_repository_to_source_path

  @question_color = "\e[34m"

  # default install variables
  @rspec              = true
  @tailwindcss        = true
  @devise             = true
  @mobile_friendly    = true
  @base_style         = true
  @hotwire            = true
  @stimulus_reflex    = false
  @omniauth           = false
  @omniauth_twitter   = false
  @omniauth_google    = false
  @omniauth_facebook  = false
  @action_text        = false
  @js_framework       = 'none'

  gather_user_input

  add_gems

  after_bundle do
    install_rspec
    install_devise
    install_tailwindcss
    install_js_framework
    install_stimulus_reflex
    install_action_text
    install_mobile_friendly_tag
    install_base_style
    install_hotwire

    create_db
    migrate_db
    stop_spring

    install_omniauth

    migrate_db
    add_bin_setup
    organize_gemfile
    initial_project_commit_and_branch
  end
end

def stop_spring
  run 'spring stop'
end

def gather_user_input
  return if no?('Would you like to customize any of the setup?', @question_color)

  input_add_devise
  input_add_base_style
  input_add_tailwindcss unless @base_style
  input_add_hotwire
  input_add_js_framework
  input_add_stimulus_reflex if using_stimulus?
  input_add_omniauth
  input_add_action_text
end

def input_add_devise
  @devise = yes?('Do you want to add Devise?', @question_color) ? @devise : false
end

def input_add_base_style
  @base_style = yes?('Would you like to add base styling?', @question_color) ? @base_style : false
end

def input_add_tailwindcss
  @tailwindcss = yes?('Would you like to add TailwindCSS?', @question_color) ? @tailwindcss : false
end

def input_add_hotwire
  @hotwire = yes?('Would you like to add Hotwire?', @question_color) ? true : false
end

def input_add_js_framework
  return if add_hotwire?

  @js_framework = ask('Would you like a JS Framework?',
                      @question_color,
                      limited_to: %w[angular react elm stimulus none])
end

def input_add_omniauth
  @omniauth = false unless yes?('Would you like to add Omniauth?', @question_color)

  unless @omniauth
    @omniauth_twitter = false
    @omniauth_facebook = false
    @omniauth_google = false
  end

  return unless @omniauth

  @omniauth_twitter   = yes?('Would you like to add Twitter Omniauth?', @question_color) ? @omniauth_twitter : false
  @omniauth_google    = yes?('Would you like to add Google Omniauth?', @question_color) ? @omniauth_google : false
  @omniauth_facebook  = yes?('Would you like to add Facebook Omniauth?', @question_color) ? @omniauth_facebook : false
end

def input_add_action_text
  @action_text = yes?('Would you like to add Action Text?', @question_color) ? @action_text : false
end

def input_add_stimulus_reflex
  return if add_hotwire?

  @stimulus_reflex = yes?('Would you like to add Stimulus Reflex?', @question_color) ? @stimulus_reflex : false
end

def add_rspec?
  @rspec
end

def add_tailwindcss?
  @tailwindcss
end

def add_base_style?
  @base_style
end

def add_js_framework?
  @js_framework != 'none'
end

def add_devise?
  @devise
end

def add_action_text?
  @action_text
end

def add_stimulus_reflex?
  @stimulus_reflex
end

def using_stimulus?
  @js_framework == 'stimulus'
end

def add_hotwire?
  @hotwire
end

def add_bin_setup
  copy_file 'bin/setup', force: true
end

def create_db
  rails_command 'db:create'
end

def migrate_db
  rails_command 'db:migrate'
end

def organize_gemfile
  run 'happy_gemfile all'
end

def initial_project_commit_and_branch
  git :init
  git add: "-A ."
  git commit: "-n -m 'Intializing a new project'"
  git checkout: "-b development"
end

# Pulled this function from https://github.com/mattbrictson/rails-template
# and modified it for including install files
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    source_paths.unshift(tempdir = Dir.mktmpdir('tinkerer-'))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      '--quiet',
      'https://github.com/dustinfisher/tinkerer.git',
      tempdir
    ].map(&:shellescape).join(' ')

    Dir[File.join(tempdir, 'install', '*.rb')].each { |file| require file }
  else
    source_paths.unshift(File.dirname(__FILE__))
    Dir[File.join(__dir__, 'install', '*.rb')].each { |file| require file }
  end
end

go_go_template!
