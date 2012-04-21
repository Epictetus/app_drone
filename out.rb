class AppBuilder < Rails::AppBuilder
  include Thor::Actions
  include Thor::Shell

  # Express app templating for Rails
  # ------------------------------------
  # USAGE:
  #   1. run: `rails new app_name --builder=path/to/builder.rb` (URI's work here too)
  #   2. ???
  #   3. PROFIT!

  def test
    return
    # TODO
    # skips test framework, but we can probably just bastardize the options in the same way as with :skip_bundle
    # either make `test` build the actual directories etc., or use a script
    # either way, this method is stupid.
  end


  def gemfile
    super
# --- 
# AppDrone::Bundle
# ---
@generator.gem 'therubyracer'
@generator.gem 'compass-rails'
@generator.gem 'slim-rails'
@generator.gem 'high_voltage'
@generator.gem 'simple_form'
@generator.gem 'compass_twitter_bootstrap', :git=>"git://github.com/vwall/compass-twitter-bootstrap.git", :group=>:assets
@generator.gem 'chosen-rails'

run_bundle
@generator.options = @generator.options.dup
@generator.options[:skip_bundle] = true
@generator.options.freeze

  end


  def leftovers
    # --- 
# AppDrone::Javascript
# ---
js_asset_path = File.join %w(app assets javascripts application.js)
@generator.remove_file(js_asset_path)
@coffee_asset_path = File.join %w(app assets javascripts application.js.coffee)
@generator.create_file @coffee_asset_path, <<-COFFEE
//= require jquery
//= require jquery_ujs
//= require chosen-jquery
//= require_tree .

$(document).ready ->
  $('.chzn-select').chosen();


COFFEE

# --- 
# AppDrone::Stylesheet
# ---
@css_asset_path = File.join %w(app assets stylesheets application.css)
@generator.remove_file(@css_asset_path)
@sass_asset_path = File.join %w(app assets stylesheets application.css.sass)

@generator.create_file @sass_asset_path, <<-SASS
/*= require chosen */
/*= require_self */

@import 'compass'
@import 'compass_twitter_bootstrap'

SASS

# --- 
# AppDrone::SlimView
# ---
erb_index_path = File.join %w(app views layouts application.html.erb)
@generator.remove_file(erb_index_path)
slim_index_path = File.join %w(app views layouts application.html.slim)
@generator.create_file slim_index_path, <<-SLIM
doctype 5
html
  head
    title #{app_name}
    = stylesheet_link_tag    'application', media: 'all'
    = javascript_include_tag 'application'
    = csrf_meta_tags

  body class=controller_name
    = yield
SLIM

# --- 
# AppDrone::HighVoltage
# ---
FileUtils.mkpath 'app/views/pages'

# --- 
# AppDrone::Flair
# ---
@generator.create_file 'app/views/pages/flair.html.slim', <<-FLAIR
h1 Flair!



h3 Bootstrap

# --- 
# AppDrone::Bootstrap
# ---
a.btn.btn-primary.btn-large Shiny!






h3 Chosen

# --- 
# AppDrone::Chosen
# ---
select.chzn-select
  option One
  option Two
  option Three



FLAIR

# --- 
# AppDrone::SimpleForm
# ---
generate "simple_form:install --bootstrap"

# --- 
# AppDrone::Cleanup
# ---
@generator.remove_file File.join %w(public index.html)
@generator.remove_file File.join %w(app assets images rails.png)
@generator.remove_file File.join %w(README.rdoc)

    rake 'db:migrate'
    say "She's all yours, sparky!\n\n", :green
  end

end
