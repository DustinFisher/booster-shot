def install_tailwindcss
  return unless add_tailwindcss?

  run 'yarn add tailwindcss --dev'
  copy_file 'app/javascript/css/tailwind.scss'
  insert_into_file 'app/views/layouts/application.html.erb',
                   before: "</head>\n" do
    <<-RUBY
    <%= stylesheet_pack_tag 'application' %>
    RUBY
  end

  insert_into_file 'app/javascript/packs/application.js',
                   after: "require(\"channels\")\n" do
    <<-RUBY
require("css/tailwind.scss")
    RUBY
  end

  gsub_file "app/javascript/packs/application.js",
            /console.log\('Hello World from Webpacker'\)\n/, ''

  insert_into_file 'postcss.config.js',
                   after: "require('postcss-import'),\n" do
    <<-RUBY
    require('tailwindcss'),
    require('autoprefixer'),
    RUBY
  end
end
