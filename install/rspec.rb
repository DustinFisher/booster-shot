def install_rspec
  generate 'rspec:install'
  run 'rm -rf test'
end
