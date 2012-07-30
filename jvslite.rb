require 'compass'
require 'sinatra'
require 'haml'

source = "http://d1zguf60fl3jx1.cloudfront.net/jvslite" #only used in one place now

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

get '/:page' do
  begin
    haml params[:page].to_sym, locals: {page: params[:page]}
  rescue Errno::ENOENT
    not_found
  end
end

not_found {haml :'404', layout: false} # graceful 404s

#get '/preview' do #replace these with :page
#  haml :preview, locals: {page: "preview"}
#end

#get '/lifestory' do
#  haml :lifestory, locals: {page: "lifestory"}
#end

#get '/pro_baseball' do
#  haml :pro_baseball, locals: {page: "pro_baseball"}
#end

#helper methods

helpers do
  def image_tag name, page=nil, options=nil # refactor with args hash
    if page
      "<img src=\"http://d1zguf60fl3jx1.cloudfront.net/jvslite/gallery/#{page}/#{name}\" #{options}>"
    else
      "<img src=\"http://d1zguf60fl3jx1.cloudfront.net/jvslite/#{name}\" #{options}>"
    end
  end

  def partial(page, options={})
    haml page.to_sym, options.merge!(:layout => false)
  end
end
