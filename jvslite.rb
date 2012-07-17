require 'compass'
require 'sinatra'
require 'haml'

source = "http://d1zguf60fl3jx1.cloudfront.net/jvslite"

configure do
  set :haml, {:format => :html5, :escape_html => false,
    locals: {source: source}}
  set :scss, {:style => :compact, :debug_info => false}
  Compass.add_project_configuration(File.join(Sinatra::Application.root, 'config', 'compass.rb'))
end

get '/stylesheets/:name.css' do
  content_type 'text/css', :charset => 'utf-8'
  scss(:"stylesheets/#{params[:name]}" )
end

# page definitions

get '/' do
  haml :index
end

get '/preview' do
  haml :preview, locals: {page: "preview"}
end

#helper methods

helpers do
  def gallery_tag name, page=nil
    if page
      "<img src=\"http://d1zguf60fl3jx1.cloudfront.net/jvslite/gallery/#{page}/#{name}\">"
    else
      "<img src=\"http://d1zguf60fl3jx1.cloudfront.net/jvslite/gallery/#{name}\">"
    end
  end
end
