def install_action_text
  return unless add_action_text?

  rails_command 'action_text:install'
end
