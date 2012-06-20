require 'compass'
require 'sinatra'
require 'haml'

configure do
  set :haml, {:format => :html5, :escape_html => false,
    locals: {source: "http://d1zguf60fl3jx1.cloudfront.net/jvslite"}}
  set :scss, {:style => :compact, :debug_info => false}
  Compass.add_project_configuration(File.join(Sinatra::Application.root, 'config', 'compass.rb'))
end

get '/stylesheets/:name.css' do
  content_type 'text/css', :charset => 'utf-8'
  scss(:"stylesheets/#{params[:name]}" )
end

get '/' do
  haml :index
end

get '/preview' do
  haml :preview
end
