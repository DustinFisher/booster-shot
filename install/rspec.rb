def install_rspec
  generate 'rspec:install'
  run 'rm -rf test'
  run 'bundle binstubs rspec-core'
end
