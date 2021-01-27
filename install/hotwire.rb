def install_hotwire
  return unless add_hotwire?

  run "bin/rails hotwire:install"
  configure_devise
end

def configure_devise
  return unless add_devise?

  copy_file 'app/controllers/users/devise_controller.rb'
  copy_file 'config/initializers/devise.rb', force: true
 end
