def install_stimulus_reflex
  return unless add_stimulus_reflex?

  run "bundle exec rails stimulus_reflex:install"
end
