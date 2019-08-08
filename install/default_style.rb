def install_default_style
	directory 'lib/templates/erb/scaffold'

  inject_into_file 'app/views/layouts/application.html.erb',
    before: "<%= yield %>\n" do <<-RUBY
  <div class="container mx-auto">
    RUBY
  end

  inject_into_file 'app/views/layouts/application.html.erb',
    after: "<%= yield %>\n" do <<-RUBY
    </div>
    RUBY
  end
end
