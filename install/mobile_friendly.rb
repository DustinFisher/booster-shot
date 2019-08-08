def install_mobile_friendly_tag
  return unless add_mobile_friendly_tag?

  insert_into_file 'app/views/layouts/application.html.erb',
                   after: "<%= csp_meta_tag %>\n" do
    <<-RUBY

    <meta name="viewport" content="width=device-width, initial-scale=1">

    RUBY
  end
end
