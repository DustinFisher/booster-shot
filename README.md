# Tinkerer
This is a rails application template used to bootstrap new projects.

When I am looking to explore a new project or some new library I use this to quickly get out a base starting point for where I want to go.

#### Setting up a new appliction
```bash
rails new appname -d postgresql -m https://raw.githubusercontent.com/DustinFisher/tinkerer/main/template.rb
```

Currently it asks a few questions to gather what to install on the initial setup.
![App Input](https://i.imgur.com/UeCt94C.png)

After it is all done you can `cd` in to the application directory and run `bin/rails s`

![](demo/example.gif)
