def install_tailwindcss
  return unless add_tailwindcss?

  run 'yarn add tailwindcss --dev'
  run './node_modules/.bin/tailwind init app/javascript/css/tailwind.js'
  copy_file 'app/javascript/css/tailwind.css'
  insert_into_file 'app/views/layouts/application.html.erb',
                   before: "</head>\n" do
    <<-RUBY
  <%= javascript_pack_tag 'application' %>
    <%= stylesheet_pack_tag 'application' %>
    RUBY
  end

  insert_into_file 'app/javascript/packs/application.js',
                   before: "console.log('Hello World from Webpacker')\n" do
    <<-RUBY
import "../css/tailwind.css";
    RUBY
  end

  gsub_file "app/javascript/packs/application.js",
            /console.log\('Hello World from Webpacker'\)\n/, ''

  insert_into_file '.postcssrc.yml',
                   after: "postcss-import: {}\n" do
    <<-RUBY
  tailwindcss: './app/javascript/css/tailwind.js'
    RUBY
  end
end
