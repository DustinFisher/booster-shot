def install_webpack
  return unless add_webpack?

  rails_command 'webpacker:install'
end
