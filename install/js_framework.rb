def install_js_framework
  return unless add_js_framework?

  run "bundle exec rails webpacker:install:#{@js_framework}"
end
