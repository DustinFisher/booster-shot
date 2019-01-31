def go_go_template!
  after_bundle do
    create_and_migrage_db
    initial_project_commit_and_branch
  end
end

def create_and_migrage_db
  rake "db:create"
  rake "db:migrate"
end

def initial_project_commit_and_branch
  git :init
  git :add => "-A ."
  git :commit => "-n -m 'Intializing a new project'"
  git :checkout => "-b development"
end

go_go_template!