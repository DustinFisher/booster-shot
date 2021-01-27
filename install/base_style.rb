def install_base_style
  return unless add_base_style?

  add_menutoggle_css
  add_application_layout_style
  add_devise_custom_views
  change_devise_locales
end

def add_menutoggle_css
  copy_file 'app/javascript/css/menutoggle.scss'

  insert_into_file 'app/javascript/css/tailwind.scss',
                   after: "@import \"tailwindcss/components\";\n" do
    <<-RUBY
@import "./menutoggle.scss";
    RUBY
  end
end

def add_application_layout_style
  gsub_file 'app/views/layouts/application.html.erb', /<body>(.*?)<\/body>/m do |match|
    <<-RUBY
  <body>
    <header class="flex flex-wrap items-center w-full shadow p-4">
      <div class="flex-1 flex justify-between items-center text-xl">
        <%= link_to 'Tinkerer', root_path %>
      </div>

      <input class="hidden" type="checkbox" id="menu-toggle" />
      <label for="menu-toggle" class="menu-icon sm:hidden">
        <span class="toggle-icon"></span>
      </label>
      <div id="menu" class="account-items sm:pt-0 sm:flex sm:items-center sm:w-auto">
        <ul class="sm:flex items-center justify-between">
          <% if user_signed_in? %>
            <li class="mr-6">
              <%= link_to('Edit registration', edit_user_registration_path) %>
            </li>
            <li>
              <%= button_to('Logout', destroy_user_session_path, method: :delete, class: 'bg-transparent cursor-pointer') %>
            </li>
          <% else %>
            <li class="mr-6">
              <%= link_to('Register', new_user_registration_path)  %>
            </li>
            <li>
              <%= link_to('Login', new_user_session_path)  %>
            </li>
          <% end %>
        </ul>
      </div>
    </header>
    <div class="content m-4">
      <p class="notice text-center text-blue-600 text-xl"><%= notice %></p>
      <p class="alert text-center text-red-600 text-xl"><%= alert %></p>
      <%= yield %>
    </div>
  </body>
    RUBY
  end

  def add_devise_custom_views
    directory 'app/views/devise'
  end

  def change_devise_locales
    gsub_file "config/locales/devise.en.yml",
              /"1 error prohibited this %{resource} from being saved:"/,
              '"1 error occurred:"'
    gsub_file "config/locales/devise.en.yml",
              /"%{count} errors prohibited this %{resource} from being saved:"/,
              '"%{count} errors occurred:"'
  end
end
